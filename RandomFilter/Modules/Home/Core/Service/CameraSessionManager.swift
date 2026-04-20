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
    
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    private(set) var currentInput: AVCaptureDeviceInput?
    
    let videoOutput = AVCaptureVideoDataOutput()
    let audioOutput = AVCaptureAudioDataOutput()
    
    func configure(recordQueue: DispatchQueue,
                   delegate: AVCaptureVideoDataOutputSampleBufferDelegate & AVCaptureAudioDataOutputSampleBufferDelegate) {
        
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .high
            
            self.setupVideoInput()
            self.setupAudioInput()
            self.setupOutputs(queue: recordQueue, delegate: delegate)
            
            self.session.commitConfiguration()
        }
    }
    
    private func setupVideoInput() {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back),
              let input = try? AVCaptureDeviceInput(device: camera),
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
    
    private func setupOutputs(queue: DispatchQueue,
                              delegate: AVCaptureVideoDataOutputSampleBufferDelegate & AVCaptureAudioDataOutputSampleBufferDelegate) {
        
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        
        videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        audioOutput.setSampleBufferDelegate(delegate, queue: queue)
        
        if session.canAddOutput(videoOutput) { session.addOutput(videoOutput) }
        if session.canAddOutput(audioOutput) { session.addOutput(audioOutput) }
    }
    
    func start() {
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stop() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func switchCamera(currentPosition: AVCaptureDevice.Position,
                      completion: @escaping (AVCaptureDevice.Position) -> Void) {
        
        sessionQueue.async {
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
            } else {
                self.session.addInput(currentInput)
            }
            
            self.session.commitConfiguration()
            
            completion(newPosition)
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
}
