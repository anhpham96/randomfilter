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
        @Published var currentDuration: Double = 0
        
        @Published var isRunning = false
        @Published var isTorchOn = false
        @Published var currentPosition: AVCaptureDevice.Position = .back
        @Published var isRecording = false
        
        @Published var recordedURL: URL?
        @Published var showPreview = false
        
        let durationValues: [Float] = [15, 30, 60, 120]
        
        // Preview stream (UI only)
        lazy var previewStream: AsyncStream<CIImage> = {
            AsyncStream { continuation in
                self.previewContinuation = continuation
            }
        }()
        
        private let ciContext: CIContext = {
            guard let device = MTLCreateSystemDefaultDevice() else {
                return CIContext(options: nil) // fallback CPU
            }
                
            return CIContext(
                mtlDevice: device,
                options: [
                    .cacheIntermediates: false,
                    .priorityRequestLow: true
                ]
            )
        }()
        
        // MARK: - Private
        
        private let sessionQueue = DispatchQueue(label: "camera.session.queue", qos: .userInitiated)
        private let recordQueue = DispatchQueue(label: "camera.record.queue", qos: .userInitiated)
        
        private var currentInput: AVCaptureDeviceInput?
        private let videoOutput = AVCaptureVideoDataOutput()
        private let audioOutput = AVCaptureAudioDataOutput()
        
        private var previewContinuation: AsyncStream<CIImage>.Continuation?
        
        private let recorder = VideoRecorder()
        
        private var recordStartTime: CMTime?
        private var didStopForDuration = false
        
        var progress: CGFloat {
            min(currentDuration / Double(selectedDuration), 1.0)
        }
        
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
                
                self.setupInput()
                self.setupOutput()
                
                self.session.commitConfiguration()
            }
        }
        
        private func setupInput() {
            self.setupVideoInput()
            self.setupAudioInput()
        }
        
        private func setupOutput() {
            self.setupVideoOutput()
            self.setupAudioOutput()
        }
        
        private func setupVideoOutput() {
            // VIDEO OUTPUT
            self.videoOutput.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
            ]
            
            self.videoOutput.setSampleBufferDelegate(self, queue: self.recordQueue)
            
            if self.session.canAddOutput(self.videoOutput) {
                self.session.addOutput(self.videoOutput)
            }
        }
        
        private func setupAudioOutput() {
            // AUDIO OUTPUT
            self.audioOutput.setSampleBufferDelegate(self, queue: self.recordQueue)
            
            if self.session.canAddOutput(self.audioOutput) {
                self.session.addOutput(self.audioOutput)
            }
        }
        
        private func setupVideoInput() {
            // CAMERA
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                        for: .video,
                                                        position: .back),
                  let videoInput = try? AVCaptureDeviceInput(device: camera),
                  self.session.canAddInput(videoInput) else {
                return
            }
            
            self.session.addInput(videoInput)
            self.currentInput = videoInput
        }
        
        private func setupAudioInput() {
            // MIC
            guard let mic = AVCaptureDevice.default(for: .audio),
                let audioInput = try? AVCaptureDeviceInput(device: mic),
                self.session.canAddInput(audioInput) else {
                return
            }
                        
            self.session.addInput(audioInput)
                        
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
            
            recordStartTime = nil
            didStopForDuration = false
            
            DispatchQueue.main.async {
                self.isRecording = true
            }
        }
        
        func stopRecord() {
            recorder.stop { url in
                print("Saved:", url ?? "")
                
                DispatchQueue.main.async {
                    self.isRecording = false
                            
                    if let url = url {
                        self.recordedURL = url
                        self.showPreview = true
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.isRecording = false
            }
        }
    }

    // MARK: - SampleBuffer Delegate

    extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate,
                             AVCaptureAudioDataOutputSampleBufferDelegate {
        
        func captureOutput(_ output: AVCaptureOutput,
                           didOutput sampleBuffer: CMSampleBuffer,
                           from connection: AVCaptureConnection) {
            
            // 🎥 VIDEO
            if output is AVCaptureVideoDataOutput {
                
                guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                    return
                }
                
                let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                
                // ⏱ set start time (frame đầu tiên)
                if recordStartTime == nil {
                    recordStartTime = time
                }
                        
                        // ⏱ elapsed + limit duration
                if let start = recordStartTime,
                    isRecording,
                    !didStopForDuration {
                            
                    let elapsed = CMTimeSubtract(time, start)
                    let elapsedSeconds = CMTimeGetSeconds(elapsed)
                            
                    // 📊 update UI realtime
                    DispatchQueue.main.async {
                        self.currentDuration = min(elapsedSeconds, Double(self.selectedDuration))
                    }
                            
                            // ⛔ stop khi đủ duration
                            if elapsedSeconds >= Double(selectedDuration) {
                                didStopForDuration = true
                                
                                DispatchQueue.main.async {
                                    self.stopRecord()
                                }
                                
                                return // 🚨 không ghi frame này nữa
                            }
                        }
                
                
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                let orientedImage = ciImage.oriented(.right) // back camera
                previewContinuation?.yield(orientedImage)
                
                if isRecording {
                    guard let newBuffer = recorder.createPixelBuffer() else { return }

                    ciContext.render(
                        orientedImage,
                        to: newBuffer,
                        bounds: orientedImage.extent,
                        colorSpace: CGColorSpaceCreateDeviceRGB()
                    )
                    
                    recorder.append(pixelBuffer: newBuffer, at: time)
                }
            }
            
            else if output is AVCaptureAudioDataOutput {
                
                if isRecording {
                    recorder.appendAudio(sampleBuffer: sampleBuffer)
                }
            }
        }
    }


extension CameraManager {
    
    func requestCameraPermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            return true
            
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    continuation.resume(returning: granted)
                }
            }
            
        case .denied, .restricted:
            return false
            
        @unknown default:
            return false
        }
    }
    
    func requestMicrophonePermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch status {
        case .authorized:
            return true
            
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .audio) { granted in
                    continuation.resume(returning: granted)
                }
            }
            
        case .denied, .restricted:
            return false
            
        @unknown default:
            return false
        }
    }
    
}

extension CameraManager {
        func switchCamera() {
            guard !isRecording else { return }
            
            sessionQueue.async {
                guard let currentInput = self.currentInput else { return }
                
                let newPosition: AVCaptureDevice.Position =
                    currentInput.device.position == .back ? .front : .back
                
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
                } else {
                    self.session.addInput(currentInput)
                }
                
                self.session.commitConfiguration()
                
                DispatchQueue.main.async {
                    self.currentPosition = newPosition
                    self.isTorchOn = false
                }
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
