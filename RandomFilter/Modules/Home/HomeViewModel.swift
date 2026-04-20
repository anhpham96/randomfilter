//
//  HomeViewModel.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//


import SwiftUI
import AVFoundation
import CoreImage
import Combine

final class HomeViewModel: NSObject, ObservableObject {
    
    // MARK: - State
    
    @Published var selectedDuration: Float = 15
    @Published var currentDuration: Double = 0
    
    @Published var isRunning = false
    @Published var isRecording = false
    
    @Published var isTorchOn = false
    @Published var currentPosition: AVCaptureDevice.Position = .back
    
    @Published var recordedURL: URL?
    @Published var showPreview = false
    
    let durationValues: [Float] = [15, 30, 60, 120]
    
    var progress: CGFloat {
        min(currentDuration / Double(selectedDuration), 1.0)
    }
    
    // MARK: - Components
    
    let sessionManager = CameraSessionManager()
    let permission = CameraPermissionService()
    let recorder = VideoRecorder()
    
    private let recordQueue = DispatchQueue(label: "camera.record.queue", qos: .userInitiated)
    
    private var recordStartTime: CMTime?
    private var didStopForDuration = false
    
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream { self.previewContinuation = $0 }
    }()
    
    private var previewContinuation: AsyncStream<CIImage>.Continuation?
    
    private let ciContext = CIContext()
    
    // MARK: - Init
    
    override init() {
        super.init()
        
        sessionManager.configure(
            recordQueue: recordQueue,
            delegate: self
        )
    }
    
    // MARK: - Control
    
    func start() {
        sessionManager.start()
        isRunning = true
    }
    
    func stop() {
        sessionManager.stop()
        isRunning = false
    }
    
    func switchCamera() {
        guard !isRecording else { return }
        
        sessionManager.switchCamera(currentPosition: currentPosition) { newPos in
            DispatchQueue.main.async {
                self.currentPosition = newPos
                self.isTorchOn = false
            }
        }
    }
    
    func toggleTorch() {
        let newValue = !isTorchOn
        
        sessionManager.setTorch(isOn: newValue) { isOn in
            DispatchQueue.main.async {
                self.isTorchOn = isOn
            }
        }
    }
    
    // MARK: - Record
    
    func startRecord() {
        recorder.prepare(config: .init(width: 1080, height: 1920))
        recorder.start()
        
        recordStartTime = nil
        didStopForDuration = false
        
        isRecording = true
    }
    
    func stopRecord() {
        recorder.stop { url in
            DispatchQueue.main.async {
                self.isRecording = false
                
                if let url {
                    self.recordedURL = url
                    self.showPreview = true
                }
            }
        }
    }
}

extension HomeViewModel: AVCaptureVideoDataOutputSampleBufferDelegate,
                         AVCaptureAudioDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        if output is AVCaptureVideoDataOutput {
            
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            
            let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let oriented = ciImage.oriented(.right)
            
            previewContinuation?.yield(oriented)
            
            guard isRecording else { return }
            
            if recordStartTime == nil {
                recordStartTime = time
            }
            
            let elapsed = CMTimeGetSeconds(CMTimeSubtract(time, recordStartTime!))
            
            DispatchQueue.main.async {
                self.currentDuration = min(elapsed, Double(self.selectedDuration))
            }
            
            if elapsed >= Double(selectedDuration) {
                stopRecord()
                return
            }
            
            guard let newBuffer = recorder.createPixelBuffer() else { return }
            
            ciContext.render(oriented,
                             to: newBuffer,
                             bounds: oriented.extent,
                             colorSpace: CGColorSpaceCreateDeviceRGB())
            
            recorder.append(pixelBuffer: newBuffer, at: time)
        }
        
        else if output is AVCaptureAudioDataOutput {
            if isRecording {
                recorder.appendAudio(sampleBuffer: sampleBuffer)
            }
        }
    }
}
