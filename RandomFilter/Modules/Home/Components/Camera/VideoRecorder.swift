//
//  VideoRecorder.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//


import AVFoundation
import CoreImage

import AVFoundation
import CoreImage

final class VideoRecorder {
    
    // MARK: - Public
    
    private(set) var isRecording = false
    private(set) var outputURL: URL?
    
    var isReady: Bool {
        input?.isReadyForMoreMediaData ?? false
    }
    
    // MARK: - Config
    
    struct Config {
        var width: Int = 1080
        var height: Int = 1920
        var bitrate: Int = 6_000_000
        var codec: AVVideoCodecType = .h264
    }
    
    private var config = Config()
    
    // MARK: - Queues
    
    private let writerQueue = DispatchQueue(label: "video.writer.queue", qos: .userInitiated)
    
    // MARK: - Writer
    
    private var writer: AVAssetWriter?
    private var input: AVAssetWriterInput?
    private var adaptor: AVAssetWriterInputPixelBufferAdaptor?
    
    private var startTime: CMTime?
    private var warmUpBuffer: CVPixelBuffer?
    
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
        writerQueue.async {
            guard !self.isRecording else { return }
            
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString + ".mp4")
            
            do {
                let writer = try AVAssetWriter(url: url, fileType: .mp4)
                
                let compression: [String: Any] = [
                    AVVideoAverageBitRateKey: self.config.bitrate
                ]
                
                let settings: [String: Any] = [
                    AVVideoCodecKey: self.config.codec,
                    AVVideoWidthKey: self.width,
                    AVVideoHeightKey: self.height,
                    AVVideoCompressionPropertiesKey: compression
                ]
                
                let input = AVAssetWriterInput(
                    mediaType: .video,
                    outputSettings: settings
                )
                
                input.expectsMediaDataInRealTime = true
                
                let attrs: [String: Any] = [
                    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
                    kCVPixelBufferWidthKey as String: self.width,
                    kCVPixelBufferHeightKey as String: self.height
                ]
                
                let adaptor = AVAssetWriterInputPixelBufferAdaptor(
                    assetWriterInput: input,
                    sourcePixelBufferAttributes: attrs
                )
                
                guard writer.canAdd(input) else { return }
                writer.add(input)
                
                writer.startWriting()
                
                // warm up buffer (fix lag frame đầu)
                if let pool = adaptor.pixelBufferPool {
                    CVPixelBufferPoolCreatePixelBuffer(nil, pool, &self.warmUpBuffer)
                }
                
                self.writer = writer
                self.input = input
                self.adaptor = adaptor
                self.startTime = nil
                self.outputURL = url
                self.isRecording = true
                
            } catch {
                print("Writer error:", error)
            }
        }
    }
    
    // MARK: - Append (NO CIIMAGE RENDER HERE)
    
    func append(pixelBuffer: CVPixelBuffer, at time: CMTime) {
        writerQueue.async {
            
            guard self.isRecording,
                  let writer = self.writer,
                  let input = self.input,
                  let adaptor = self.adaptor,
                  input.isReadyForMoreMediaData else {
                return
            }
            
            if self.startTime == nil {
                writer.startSession(atSourceTime: time)
                self.startTime = time
            }
            
            adaptor.append(pixelBuffer, withPresentationTime: time)
        }
    }
    
    // MARK: - Stop
    
    func stop(completion: @escaping (URL?) -> Void) {
        writerQueue.async {
            
            guard self.isRecording,
                  let writer = self.writer,
                  let input = self.input else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            self.isRecording = false
            
            input.markAsFinished()
            
            writer.finishWriting {
                let url = writer.outputURL
                
                self.writer = nil
                self.input = nil
                self.adaptor = nil
                self.startTime = nil
                self.warmUpBuffer = nil
                
                DispatchQueue.main.async {
                    completion(url)
                }
            }
        }
    }
}
