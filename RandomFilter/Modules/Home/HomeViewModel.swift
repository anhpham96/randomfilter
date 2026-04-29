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

final class HomeViewModel: BaseViewModel {
    
    // MARK: - State
    
    @Published var selectedDuration: Double = 15
    @Published var currentDuration: Double = 0
    @Published var isRunning = false
    @Published var isRecording = false
    @Published var isTorchOn = false
    @Published var currentPosition: AVCaptureDevice.Position = .back
    @Published var permissionState: PermissionState = .idle
    @Published var isPaywallViewPresented: Bool = false
    
    @Published var zoomFactor: CGFloat = 1.0
    
    @Published var countdownSeconds: Int = 0
    @Published var isCountdownOn: Bool = false
    @Published var isCountingDown: Bool = false
    var limitTimer: Int = 5

    private var countdownTask: Task<Void, Never>?

    @Published var hasTorch: Bool = false

    
    let durationValues: [Double] = [15, 30, 60, 120]
    
    let event = PassthroughSubject<HomeEvent, Never>()

    var progress: CGFloat {
        min(currentDuration / Double(selectedDuration), 1.0)
    }
    
    // MARK: - Components
    
    let sessionManager = CameraSessionManager()
    let recorder = VideoRecorder()
    let permission = CameraPermissionService()
    
    private let ciContext = CIContext(
        mtlDevice: MTLCreateSystemDefaultDevice()!
    )
    private let videoProcessor: VideoFrameProcessor
    private let audioProcessor: AudioFrameProcessor
    
    // MARK: - Init
    
    override init() {
        
        self.videoProcessor = VideoFrameProcessor(selectedDuration: 15,
            recorder: recorder,
            ciContext: ciContext,
            isFrontCamera: sessionManager.isFrontCamera
        )
        self.audioProcessor = AudioFrameProcessor(recorder: recorder)
        
        super.init()
        bindProcessor()
        
        sessionManager.configure(delegate: self)
        
        sessionManager.$cameraPosition
            .sink { [weak self] position in
                self?.videoProcessor.isFrontCamera = position == .front
            }.store(in: &bag)
        
        sessionManager.$currentInput
            .sink { [weak self] currentInput in
                DispatchQueue.main.async(execute: {
                    self?.hasTorch = currentInput?.device.hasTorch ?? false
                })
            }.store(in: &bag)
        
        $selectedDuration
            .sink { [weak self] selectedDuration in
                self?.videoProcessor.updateSelectedDuration(selectedDuration)
            }.store(in: &bag)
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
    
    func tapOnRecordingButton() {
        if isRecording { return stopRecord() }
        if isCountingDown { return stopCountdown() }
        if isCountdownOn { return startCountdown() }
        return startRecord()
    }
    
    func start() {
        sessionManager.start()
        isRunning = true
    }
    
    func stop() {
        sessionManager.stop()
        isRunning = false
    }
    
    // MARK: - Record
    
    private func startRecord() {
        recorder.prepare(config: .init(width: 1080, height: 1920))
        recorder.start()
        
        videoProcessor.reset()
        
        currentDuration = 0
        withAnimation(.linear(duration: 0.4)) {
            isRecording = true

        }
        
    }
    
    private func stopRecord() {
        recorder.stop { url in
            DispatchQueue.main.async {
                self.isRecording = false
                
                if let url {
                    self.event.send(.showResult(url: url))
                }
            }
        }
    }
    
    func toggleTorch() {
        sessionManager.toggleTorch { isTorchOn  in
            DispatchQueue.main.async {
                
                self.isTorchOn = isTorchOn
            }
        }
    }
    
    func switchCamera() {
        sessionManager.switchCamera()
    }
    
    func startCountdown() {
        countdownTask?.cancel()
        
        countdownTask = Task {
            countdownSeconds = limitTimer
            isCountingDown = true
            
            while countdownSeconds > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                
                if Task.isCancelled { return }
                
                countdownSeconds -= 1
            }
            
            countdownSeconds = 0
            isCountingDown = false
            startRecord()
        }
    }

    func stopCountdown() {
        countdownTask?.cancel()
        countdownTask = nil
        
        isCountingDown = false
        countdownSeconds = 0
    }
    
    func zoom(factor: CGFloat) async {
        let zoomFactor = await sessionManager.zoom(factor: factor)
        
        await MainActor.run {
            self.zoomFactor = zoomFactor
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
