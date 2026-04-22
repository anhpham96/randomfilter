//
//  AudioFrameProcessor.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 20/4/26.
//


import AVFoundation

final class AudioFrameProcessor {
    
    private let recorder: VideoRecorder
    
    init(recorder: VideoRecorder) {
        self.recorder = recorder
    }
    
    func process(sampleBuffer: CMSampleBuffer, isRecording: Bool) {
        guard isRecording else { return }
        recorder.appendAudio(sampleBuffer: sampleBuffer)
    }
}
