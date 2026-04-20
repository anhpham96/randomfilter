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
    
    @Published var permissionState: PermissionState = .idle
    
    let durationValues: [Float] = [15, 30, 60, 120]
    
    var progress: CGFloat {
        min(currentDuration / Double(selectedDuration), 1.0)
    }
    
    // MARK: - Components
    
    let sessionManager = CameraSessionManager()
    let recorder = VideoRecorder()
    let permission = CameraPermissionService()
    
    private let ciContext = CIContext()
    private let recordQueue = DispatchQueue(label: "camera.record.queue", qos: .userInitiated)
    
    private let videoProcessor: VideoFrameProcessor
    private let audioProcessor: AudioFrameProcessor
    
    private var previewContinuation: AsyncStream<CIImage>.Continuation?
    
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream { continuation in
            self.previewContinuation = continuation
        }
    }()
    
    // MARK: - Init
    
    override init() {
        
        self.videoProcessor = VideoFrameProcessor(
            selectedDuration: 15,
            recorder: recorder,
            ciContext: ciContext
        )
        
        self.audioProcessor = AudioFrameProcessor(recorder: recorder)
        
        super.init()
        
        videoProcessor.previewContinuation = previewContinuation
        
        bindProcessor()
        
        sessionManager.configure(
            recordQueue: recordQueue,
            delegate: self
        )
    }
    
    private func bindProcessor() {
        
        videoProcessor.onProgress = { [weak self] value in
            DispatchQueue.main.async {
                guard let self else { return }
                self.currentDuration = min(value, Double(self.selectedDuration))
            }
        }
        
        videoProcessor.onStopRequested = { [weak self] in
            self?.stopRecord()
        }
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
    
    // MARK: - Record
    
    func startRecord() {
        recorder.prepare(config: .init(width: 1080, height: 1920))
        recorder.start()
        
        videoProcessor.reset()
        
        currentDuration = 0
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
    
    func toggleTorch() {
        sessionManager.toggleTorch { _ in
            
        }
    }
    
    func prepareCamera() async {
        let cameraOK = await permission.requestCamera()
        let micOK = await permission.requestMic()
        
        await MainActor.run {
            if cameraOK && micOK {
                self.permissionState = .granted
            } else {
                self.permissionState = .denied
            }
        }
        
        if cameraOK && micOK {
            start()
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
            
            videoProcessor.process(
                pixelBuffer: pixelBuffer,
                time: time,
                isRecording: isRecording
            )
        }
        
        else if output is AVCaptureAudioDataOutput {
            
            audioProcessor.process(
                sampleBuffer: sampleBuffer,
                isRecording: isRecording
            )
        }
    }
}
