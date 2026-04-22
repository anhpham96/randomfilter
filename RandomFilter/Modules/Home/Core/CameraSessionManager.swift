//
//  CameraSessionManager.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 20/4/26.
//


import AVFoundation
import Combine

final class CameraSessionManager: NSObject {
    
    let session = AVCaptureSession()
    
    private let sessionQueue = DispatchQueue(label: QueueLabel.cameraSession.rawValue)
    private let captureOutputQueue = DispatchQueue(label: QueueLabel.captureOutput.rawValue)

    @Published private(set) var currentInput: AVCaptureDeviceInput?
    
    let videoOutput = AVCaptureVideoDataOutput()
    let audioOutput = AVCaptureAudioDataOutput()
    
    private let minZoomFactor: CGFloat = 1.0
    private let maxZoomFactor: CGFloat = 5.0
    
    var isFrontCamera: Bool {
        currentInput?.device.position == .front
    }
    
    var hasTorch: Bool {
        currentInput?.device.hasTorch ?? false
    }
    
    @Published private(set) var cameraPosition: AVCaptureDevice.Position = .back
    
    func configure(delegate: AVCaptureVideoDataOutputSampleBufferDelegate &
                   AVCaptureAudioDataOutputSampleBufferDelegate) {
        
        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            self.session.beginConfiguration()
            self.session.sessionPreset = .high
            
            self.setupVideoInput()
            self.setupAudioInput()
            self.setupOutputs(delegate: delegate)
            
            self.session.commitConfiguration()
        }
    }
    
    private func setupVideoInput() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else { return }
        
        session.addInput(input)
        currentInput = input
    }
    
    private func setupAudioInput() {
        guard let mic = AVCaptureDevice.default(for: .audio),
              let input = try? AVCaptureDeviceInput(device: mic),
              session.canAddInput(input) else { return }
        
        session.addInput(input)
    }
    
    private func setupOutputs(
                              delegate: AVCaptureVideoDataOutputSampleBufferDelegate &
                              AVCaptureAudioDataOutputSampleBufferDelegate) {
        
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        
        videoOutput.setSampleBufferDelegate(delegate, queue: captureOutputQueue)
        audioOutput.setSampleBufferDelegate(delegate, queue: captureOutputQueue)
        
        if session.canAddOutput(videoOutput) { session.addOutput(videoOutput) }
        if session.canAddOutput(audioOutput) { session.addOutput(audioOutput) }
        
        self.configureVideoConnection(position: currentInput?.device.position ?? .back)
    }
    
    func start() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stop() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func switchCamera() -> Void {
        
        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            guard let currentInput = self.currentInput else { return }
            
            let newPosition: AVCaptureDevice.Position =
            currentInput.device.position == .back ? .front : .back
            
            guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                          for: .video,
                                                          position: newPosition),
                  let newInput = try? AVCaptureDeviceInput(device: newDevice) else { return }
            
            self.session.beginConfiguration()
            
            self.session.removeInput(currentInput)
            
            if self.session.canAddInput(newInput) {
                self.session.addInput(newInput)
                self.currentInput = newInput
                
                self.cameraPosition = newPosition
                
                self.configureVideoConnection(position: newPosition)
            } else {
                self.session.addInput(currentInput)
            }
            
            self.session.commitConfiguration()
            
        }
    }
    
    func setTorch(isOn: Bool, completion: @escaping (Bool) -> Void) {
        sessionQueue.async {
            guard let device = self.currentInput?.device,
                  device.hasTorch else { return }
            
            do {
                try device.lockForConfiguration()
                
                if isOn {
                    try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
                completion(isOn)
            } catch {
                print(error)
            }
        }
    }
    
    func toggleTorch(completion: @escaping (Bool) -> Void) {
        sessionQueue.async {
            guard let device = self.currentInput?.device,
                  device.hasTorch else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            let newValue = device.torchMode != .on
            
            self.setTorch(isOn: newValue) { _ in
                completion(newValue)
            }
        }
    }
    

    func zoom(factor: CGFloat) async -> CGFloat {
        await withCheckedContinuation { continuation in
            sessionQueue.async { [weak self] in
                guard let self = self,
                      let device = self.currentInput?.device else {
                    continuation.resume(returning: factor)
                    return
                }

                do {
                    try device.lockForConfiguration()

                    let maxDeviceZoom = device.activeFormat.videoMaxZoomFactor
                    let maxZoom = min(self.maxZoomFactor, maxDeviceZoom)

                    let clampedZoom = max(self.minZoomFactor,
                                          min(factor, maxZoom))

                    device.videoZoomFactor = clampedZoom

                    device.unlockForConfiguration()

                    continuation.resume(returning: clampedZoom)

                } catch {
                    print("Zoom error: \(error.localizedDescription)")
                    continuation.resume(returning: factor)
                }
            }
        }
    }
    
    private func configureVideoConnection(position: AVCaptureDevice.Position) {
        guard let connection = videoOutput.connection(with: .video) else { return }
        
        // Rotation (portrait)
        if connection.isVideoRotationAngleSupported(90) {
            connection.videoRotationAngle = 90
        }
        
        // Mirror for front camera
        connection.isVideoMirrored = (position == .front)
    }
    
    
    
}
