//
//  VideoFrameProcessor.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 20/4/26.
//


import AVFoundation
import CoreImage

final class VideoFrameProcessor {
    
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
         ciContext: CIContext) {
        self.selectedDuration = selectedDuration
        self.recorder = recorder
        self.ciContext = ciContext
    }
    
    func reset() {
        recordStartTime = nil
        didStopForDuration = false
    }
    
    func process(pixelBuffer: CVPixelBuffer,
                 time: CMTime,
                 isRecording: Bool) {
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let oriented = ciImage.oriented(.right)
        
        previewContinuation?.yield(oriented)
        
        guard isRecording else { return }
        
        if recordStartTime == nil {
            recordStartTime = time
            onFirstFrame?(time)
        }
        
        guard let start = recordStartTime else { return }
        
        let elapsed = CMTimeGetSeconds(CMTimeSubtract(time, start))
        onProgress?(elapsed)
        
        if elapsed >= selectedDuration, !didStopForDuration {
            didStopForDuration = true
            onStopRequested?()
            return
        }
        
        guard let buffer = recorder.createPixelBuffer() else { return }
        
        ciContext.render(
            oriented,
            to: buffer,
            bounds: oriented.extent,
            colorSpace: CGColorSpaceCreateDeviceRGB()
        )
        
        recorder.append(pixelBuffer: buffer, at: time)
    }
}
