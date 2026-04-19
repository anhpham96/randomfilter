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
    
    let durationValues: [Float] = [15, 30, 60, 120]
    
    // Stream cho SwiftUI / filter pipeline
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream { continuation in
            self.previewContinuation = continuation
        }
    }()
    
    // MARK: - Private
    
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    private var currentInput: AVCaptureDeviceInput?
    private let videoOutput = AVCaptureVideoDataOutput()
    
    private var previewContinuation: AsyncStream<CIImage>.Continuation?
    
    private let ciContext = CIContext()
    
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
            
            // Input
            self.setupInput(position: .back)
            
            // Output
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
        
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        guard session.canAddOutput(videoOutput) else { return }
        session.addOutput(videoOutput)
        
        videoOutput.connection(with: .video)?.videoRotationAngle = 0
    }
    
    // MARK: - Control
    
    func start() {
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
                DispatchQueue.main.async {
                    self.isRunning = true
                }
            }
        }
    }
    
    func stop() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
                DispatchQueue.main.async {
                    self.isRunning = false
                }
            }
        }
    }
    
    // MARK: - Switch Camera
    
    func switchCamera() {
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
            
            self.session.removeInput(currentInput)
            
            if self.session.canAddInput(newInput) {
                self.session.addInput(newInput)
                self.currentInput = newInput
                
                DispatchQueue.main.async {
                    self.currentPosition = newPosition
                    self.isTorchOn = false // reset torch
                }
            } else {
                self.session.addInput(currentInput)
            }
            
            self.session.commitConfiguration()
        }
    }
    
    // MARK: - Torch
    
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
                print("Torch error: \(error)")
            }
        }
    }
    
    func toggleTorch() {
        guard let device = currentInput?.device,
              device.hasTorch else { return }
        
        setTorch(isOn: device.torchMode != .on)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        previewContinuation?.yield(ciImage)
    }
}
