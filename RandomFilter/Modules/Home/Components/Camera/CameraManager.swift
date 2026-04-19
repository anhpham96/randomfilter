//
//  CameraManager.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//


import AVFoundation

import Combine

final class CameraManager: NSObject, ObservableObject {
    
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    override init() {
        super.init()
        configure()
    }
    
    private func configure() {
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .high
            
            // Input (camera)
            guard let camera = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: camera),
                  self.session.canAddInput(input) else {
                return
            }
            self.session.addInput(input)
            
            self.session.commitConfiguration()
        }
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
}
