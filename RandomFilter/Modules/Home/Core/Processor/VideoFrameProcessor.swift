//
//  VideoFrameProcessor.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 20/4/26.
//


import AVFoundation
import CoreImage

final class VideoFrameProcessor {
    
    var isFrontCamera: Bool
    var previewContinuation: AsyncStream<CIImage>.Continuation?
    
    var onFirstFrame: ((CMTime) -> Void)?
    var onProgress: ((Double) -> Void)?
    var onStopRequested: (() -> Void)?
    
    private var recordStartTime: CMTime?
    private var didStopForDuration = false
    
    private let selectedDuration: Double
    private let recorder: VideoRecorder
    private let ciContext: CIContext
    
    init(selectedDuration: Double,
         recorder: VideoRecorder,
         ciContext: CIContext,
         isFrontCamera: Bool) {
        self.selectedDuration = selectedDuration
        self.recorder = recorder
        self.ciContext = ciContext
        self.isFrontCamera = isFrontCamera
    }
    
    func reset() {
        recordStartTime = nil
        didStopForDuration = false
    }
    
    // MARK: - Public entry point (MAIN PIPELINE)
    func process(pixelBuffer: CVPixelBuffer,
                time: CMTime,
                isRecording: Bool) {
            
            let image = makeCIImage(from: pixelBuffer)
            
            sendPreview(image)
            
            guard isRecording else { return }
            
            handleRecordingStartIfNeeded(time: time)
            
            updateProgress(time: time)
            
            checkAutoStop(time: time)
            
            recordFrame(image: image, time: time)
    }
    
}

private extension VideoFrameProcessor {
    
    func sendPreview(_ image: CIImage) {
        previewContinuation?.yield(image)
    }
}

private extension VideoFrameProcessor {
    
    func handleRecordingStartIfNeeded(time: CMTime) {
        guard recordStartTime == nil else { return }
        
        recordStartTime = time
        onFirstFrame?(time)
    }
}

private extension VideoFrameProcessor {
    
    func updateProgress(time: CMTime) {
        guard let start = recordStartTime else { return }
        
        let elapsed = CMTimeGetSeconds(CMTimeSubtract(time, start))
        onProgress?(elapsed)
    }
}

private extension VideoFrameProcessor {
    
    func checkAutoStop(time: CMTime) {
        guard let start = recordStartTime else { return }
        guard !didStopForDuration else { return }
        
        let elapsed = CMTimeGetSeconds(CMTimeSubtract(time, start))
        
        guard elapsed >= selectedDuration else { return }
        
        didStopForDuration = true
        onStopRequested?()
    }
}

private extension VideoFrameProcessor {
    
    func recordFrame(image: CIImage, time: CMTime) {
        guard let buffer = recorder.createPixelBuffer() else { return }
        
        render(image: image, into: buffer)
        
        recorder.append(pixelBuffer: buffer, at: time)
    }
}

private extension VideoFrameProcessor {
    
    func makeCIImage(from pixelBuffer: CVPixelBuffer) -> CIImage {
        
        let image = CIImage(cvPixelBuffer: pixelBuffer)
        return image
    }
    
    func render(image: CIImage, into buffer: CVPixelBuffer) {
        ciContext.render(
            image,
            to: buffer,
            bounds: image.extent,
            colorSpace: CGColorSpaceCreateDeviceRGB()
        )
    }
}
