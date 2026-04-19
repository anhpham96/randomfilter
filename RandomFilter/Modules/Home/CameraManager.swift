//
//  CameraManager.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//


import AVFoundation
import Combine

import AVFoundation

final class CameraManager: NSObject, ObservableObject {
    
    // MARK: - Public
    let session = AVCaptureSession()
    
    // MARK: - Private
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private var currentInput: AVCaptureDeviceInput?
    
    // MARK: - Init
    override init() {
        super.init()
        checkPermissionAndSetup()
    }
    
    // MARK: - Permission
    private func checkPermissionAndSetup() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupSession()
                }
            }
            
        default:
            print("❌ Camera permission denied")
        }
    }
    
    // MARK: - Setup
    private func setupSession() {
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            
            // Input mặc định: camera sau
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video,
                                                       position: .back),
                  let input = try? AVCaptureDeviceInput(device: device),
                  self.session.canAddInput(input) else {
                print("❌ Cannot add camera input")
                return
            }
            
            self.session.addInput(input)
            self.currentInput = input
            
            self.session.commitConfiguration()
            self.start()
        }
    }
    
    // MARK: - Control
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
    
    // MARK: - Switch Camera
    func switchCamera() {
        sessionQueue.async {
            guard let currentInput = self.currentInput else { return }
            
            let newPosition: AVCaptureDevice.Position =
                currentInput.device.position == .back ? .front : .back
            
            guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                          for: .video,
                                                          position: newPosition),
                  let newInput = try? AVCaptureDeviceInput(device: newDevice) else {
                print("❌ Cannot switch camera")
                return
            }
            
            self.session.beginConfiguration()
            self.session.removeInput(currentInput)
            
            if self.session.canAddInput(newInput) {
                self.session.addInput(newInput)
                self.currentInput = newInput
            } else {
                self.session.addInput(currentInput) // rollback
            }
            
            self.session.commitConfiguration()
        }
    }
}
