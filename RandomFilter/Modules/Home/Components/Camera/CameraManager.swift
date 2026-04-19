//
//  CameraManager.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//


//
//  CameraManager.swift
//  RandomFilter
//

import AVFoundation
import Combine
import CoreImage

final class CameraManager: NSObject, ObservableObject {
    
    // MARK: - Public
    
    let session = AVCaptureSession()
    
    @Published var selectedDuration: Float = 15
    @Published var isRunning = false
    @Published var isTorchOn = false
    @Published var currentPosition: AVCaptureDevice.Position = .back
    @Published var isRecording = false
    
    let durationValues: [Float] = [15, 30, 60, 120]
    
    // Preview stream (UI only)
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream { continuation in
            self.previewContinuation = continuation
        }
    }()
    
    // MARK: - Private
    
    private let sessionQueue = DispatchQueue(label: "camera.session.queue", qos: .userInitiated)
    private let recordQueue = DispatchQueue(label: "camera.record.queue", qos: .userInitiated)
    
    private var currentInput: AVCaptureDeviceInput?
    private let videoOutput = AVCaptureVideoDataOutput()
    private var previewContinuation: AsyncStream<CIImage>.Continuation?
    
    private let recorder = VideoRecorder()
    
    // MARK: - Init
    
    override init() {
        super.init()
        configure()
    }
    
    // MARK: - Setup
    
    private func configure() {
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .high
            
            self.setupInput(position: .back)
            self.setupOutput()
            
            self.session.commitConfiguration()
        }
    }
    
    private func setupInput(position: AVCaptureDevice.Position) {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: position),
              let input = try? AVCaptureDeviceInput(device: device),
              self.session.canAddInput(input) else {
            return
        }
        
        self.session.addInput(input)
        self.currentInput = input
        
        DispatchQueue.main.async {
            self.currentPosition = position
        }
    }
    
    private func setupOutput() {
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String:
                kCVPixelFormatType_32BGRA
        ]
        
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        guard session.canAddOutput(videoOutput) else { return }
        session.addOutput(videoOutput)
    }
    
    // MARK: - Control
    
    func start() {
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
                DispatchQueue.main.async { self.isRunning = true }
            }
        }
    }
    
    func stop() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
                DispatchQueue.main.async { self.isRunning = false }
            }
        }
    }
    
    // MARK: - Record
    
    func startRecord() {
        recorder.prepare(config: .init(width: 1080, height: 1920))
        
        recorder.start()
        
        DispatchQueue.main.async {
            self.isRecording = true
        }
    }
    
    func stopRecord() {
        recorder.stop { url in
            print("Saved:", url ?? "")
        }
        
        DispatchQueue.main.async {
            self.isRecording = false
        }
    }
}

// MARK: - SampleBuffer Delegate

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // 1. Preview only
        previewContinuation?.yield(ciImage)
        
        // 2. Record ONLY pixelBuffer (no CI render)
        if isRecording {
            recorder.append(pixelBuffer: pixelBuffer, at: time)
        }
    }
}

extension CameraManager {
    func switchCamera() {
        guard !self.isRecording else { return }
        
        sessionQueue.async {
            guard let currentInput = self.currentInput else { return }
            
            let newPosition: AVCaptureDevice.Position =
                (currentInput.device.position == .back) ? .front : .back
            
            guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                          for: .video,
                                                          position: newPosition),
                  let newInput = try? AVCaptureDeviceInput(device: newDevice) else {
                return
            }
            
            self.session.beginConfiguration()
            self.session.sessionPreset = .high
            
            // remove old
            self.session.removeInput(currentInput)
            
            // add new safely
            if self.session.canAddInput(newInput) {
                self.session.addInput(newInput)
                self.currentInput = newInput
                
                DispatchQueue.main.async {
                    self.currentPosition = newPosition
                    self.isTorchOn = false
                }
            } else {
                // rollback nếu fail
                self.session.addInput(currentInput)
            }
            
            self.session.commitConfiguration()
        }
    }
    
    func setTorch(isOn: Bool) {
        sessionQueue.async {
            guard let device = self.currentInput?.device,
                  device.hasTorch else {
                return
            }
            
            do {
                try device.lockForConfiguration()
                
                if isOn {
                    try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
                
                DispatchQueue.main.async {
                    self.isTorchOn = isOn
                }
                
            } catch {
                print("Torch error:", error)
            }
        }
    }
    
    func toggleTorch() {
        sessionQueue.async {
            guard let device = self.currentInput?.device,
                  device.hasTorch else { return }
            
            let newValue = device.torchMode == .on ? false : true
            
            self.setTorch(isOn: newValue)
        }
    }
}
//// MARK: - Switch Camera
//
//func switchCamera() {
//    sessionQueue.async {
//        guard let currentInput = self.currentInput else { return }
//        
//        let newPosition: AVCaptureDevice.Position =
//            (currentInput.device.position == .back) ? .front : .back
//        
//        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
//                                                      for: .video,
//                                                      position: newPosition),
//              let newInput = try? AVCaptureDeviceInput(device: newDevice) else {
//            return
//        }
//        
//        self.session.beginConfiguration()
//        
//        self.session.removeInput(currentInput)
//        
//        if self.session.canAddInput(newInput) {
//            self.session.addInput(newInput)
//            self.currentInput = newInput
//            
//            DispatchQueue.main.async {
//                self.currentPosition = newPosition
//                self.isTorchOn = false // reset torch
//            }
//        } else {
//            self.session.addInput(currentInput)
//        }
//        
//        self.session.commitConfiguration()
//    }
//}
//
//// MARK: - Torch
//
//func setTorch(isOn: Bool) {
//    sessionQueue.async {
//        guard let device = self.currentInput?.device,
//              device.hasTorch else {
//            return
//        }
//        
//        do {
//            try device.lockForConfiguration()
//            
//            if isOn {
//                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
//            } else {
//                device.torchMode = .off
//            }
//            
//            device.unlockForConfiguration()
//            
//            DispatchQueue.main.async {
//                self.isTorchOn = isOn
//            }
//            
//        } catch {
//            print("Torch error: \(error)")
//        }
//    }
//}
//
//func toggleTorch() {
//    guard let device = currentInput?.device,
//          device.hasTorch else { return }
//    
//    setTorch(isOn: device.torchMode != .on)
//}
