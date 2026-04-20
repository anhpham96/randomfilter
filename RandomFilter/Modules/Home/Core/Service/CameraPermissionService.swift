//
//  CameraPermissionService.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 20/4/26.
//


import AVFoundation

final class CameraPermissionService {
    
    func requestCamera() async -> Bool {
        await request(for: .video)
    }
    
    func requestMic() async -> Bool {
        await request(for: .audio)
    }
    
    private func request(for type: AVMediaType) async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: type)
        
        switch status {
        case .authorized:
            return true
            
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: type) { granted in
                    continuation.resume(returning: granted)
                }
            }
            
        default:
            return false
        }
    }
}
