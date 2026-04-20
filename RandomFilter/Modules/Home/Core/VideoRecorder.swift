//
//  VideoRecorder.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//


import AVFoundation
import CoreImage

import UIKit

final class VideoRecorder {
    
    // MARK: - Public
    private(set) var isRecording = false
    private(set) var outputURL: URL?
    
    var isReady: Bool {
        videoInput?.isReadyForMoreMediaData ?? false
    }
    
    // MARK: - Config
    struct Config {
        var width: Int = 1080
        var height: Int = 1920
        var bitrate: Int = 6_000_000
        var codec: AVVideoCodecType = .h264
    }
    
    private var config = Config()
    
    // MARK: - Queue (IMPORTANT)
    private let recordQueue = DispatchQueue(label: "video.record.queue", qos: .userInitiated)
    
    // MARK: - Writer
    private var writer: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var audioInput: AVAssetWriterInput?
    private var adaptor: AVAssetWriterInputPixelBufferAdaptor?
    
    private var startTime: CMTime?
    private var width: Int = 1080
    private var height: Int = 1920
    
    // MARK: - Setup
    func prepare(config: Config = Config()) {
        self.config = config
        self.width = config.width
        self.height = config.height
    }
    
    // MARK: - Start
    func start() {
        recordQueue.async {
            guard !self.isRecording else { return }
            
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString + ".mp4")
            
            do {
                let writer = try AVAssetWriter(url: url, fileType: .mp4)
                
                // VIDEO INPUT
                let videoSettings: [String: Any] = [
                    AVVideoCodecKey: self.config.codec,
                    AVVideoWidthKey: self.width,
                    AVVideoHeightKey: self.height,
                    AVVideoCompressionPropertiesKey: [
                        AVVideoAverageBitRateKey: self.config.bitrate
                    ]
                ]
                
                let videoInput = AVAssetWriterInput(
                    mediaType: .video,
                    outputSettings: videoSettings
                )
                videoInput.expectsMediaDataInRealTime = true
                
                let attrs: [String: Any] = [
                    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
                    kCVPixelBufferWidthKey as String: self.width,
                    kCVPixelBufferHeightKey as String: self.height
                ]
                
                let adaptor = AVAssetWriterInputPixelBufferAdaptor(
                    assetWriterInput: videoInput,
                    sourcePixelBufferAttributes: attrs
                )
                
                // AUDIO
                let audioSettings: [String: Any] = [
                    AVFormatIDKey: kAudioFormatMPEG4AAC,
                    AVNumberOfChannelsKey: 1,
                    AVSampleRateKey: 44100,
                    AVEncoderBitRateKey: 128000
                ]
                
                let audioInput = AVAssetWriterInput(
                    mediaType: .audio,
                    outputSettings: audioSettings
                )
                audioInput.expectsMediaDataInRealTime = true
                
                // ADD
                guard writer.canAdd(videoInput) else { return }
                writer.add(videoInput)
                
                if writer.canAdd(audioInput) {
                    writer.add(audioInput)
                }
                
               writer.startWriting()
                
                self.writer = writer
                self.videoInput = videoInput
                self.audioInput = audioInput
                self.adaptor = adaptor
                self.outputURL = url
                self.isRecording = true
                self.startTime = nil
                
            } catch {
                print("Writer error:", error)
            }
        }
    }
    
    // MARK: Video
    func append(pixelBuffer: CVPixelBuffer, at time: CMTime) {
        recordQueue.async {
            guard self.isRecording,
                  let writer = self.writer,
                  let input = self.videoInput,
                  let adaptor = self.adaptor else { return }
                
                // 🔥 START SESSION (FIX CRASH)
            if self.startTime == nil {
                if writer.status == .failed {
                    print("❌ writer failed:", writer.error as Any)
                    return
                }
                print("Start Session")
                writer.startSession(atSourceTime: time)
                self.startTime = time
            }
                
            guard writer.status == .writing,
                      input.isReadyForMoreMediaData else { return }
                
            adaptor.append(pixelBuffer, withPresentationTime: time)
        }
    }
    
    // MARK: Audio
    func appendAudio(sampleBuffer: CMSampleBuffer) {
        recordQueue.async {
            guard self.isRecording,
                self.startTime != nil,
                let writer = self.writer,
                let audioInput = self.audioInput,
                writer.status == .writing,
                audioInput.isReadyForMoreMediaData else { return }
                
                audioInput.append(sampleBuffer)
        }
    }
    
    func createPixelBuffer() -> CVPixelBuffer? {
        guard let pool = adaptor?.pixelBufferPool else { return nil }
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferPoolCreatePixelBuffer(nil, pool, &pixelBuffer)
        
        if status != kCVReturnSuccess {
            return nil
        }
        
        return pixelBuffer
    }
    
    // MARK: - Stop
    func stop(completion: @escaping (URL?) -> Void) {
        recordQueue.async {
            guard self.isRecording,
                  let writer = self.writer,
                  let videoInput = self.videoInput else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            guard writer.status == .writing else {
                self.cleanup()
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.isRecording = false
            
            videoInput.markAsFinished()
            self.audioInput?.markAsFinished()
            
            writer.finishWriting {
                let url = writer.outputURL
                
                self.cleanup()
                
                DispatchQueue.main.async {
                    completion(url)
                }
            }
        }
    }
    
    private func cleanup() {
        self.writer = nil
        self.videoInput = nil
        self.audioInput = nil
        self.adaptor = nil
        self.startTime = nil
    }
}
