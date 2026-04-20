//
//  ResultViewModel.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 20/4/26.
//


import Foundation
import Photos
import Combine

@MainActor
final class ResultViewModel: BaseViewModel {
    
    enum SaveState {
        case idle
        case saving
        case saved
        case failed
    }
    
    @Published var state: SaveState = .idle
    
    func saveVideo(from url: URL) async {
        guard state != .saving else { return }
        
        state = .saving
        
        do {
            try await saveToPhotoLibrary(fileURL: url)
            state = .saved
        } catch {
            state = .failed
            print("Save error:", error)
        }
    }
    
    private func saveToPhotoLibrary(fileURL: URL) async throws {
        
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        
        guard status == .authorized || status == .limited else {
            throw NSError(domain: "PhotoPermissionDenied", code: 1)
        }
        
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }
    }
}
