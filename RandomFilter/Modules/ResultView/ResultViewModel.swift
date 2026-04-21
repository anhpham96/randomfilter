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
      
    let url: URL
    
    @Published var state: SaveState = .idle
    @Published var showErrorAlert = false
    @Published var errorMessage: String = ""
    
    let event = PassthroughSubject<ResultEvent, Never>()
    
    init(url: URL) {
        self.url = url
    }
    
    func tapSaveButton() async {
        guard state != .saving else { return }
        state = .saving
        do {
            try await saveToPhotoLibrary(fileURL: url)
            state = .saved
            
            removeLocalFile(url)
        } catch {
            state = .failed
            errorMessage = error.localizedDescription
            showErrorAlert = true
            print("Save error:", error)
        }
    }
    
    func tapRetryButton() {
        // reset state trước
        state = .idle
        showErrorAlert = false
        errorMessage = ""
        
        // optional: dọn file cũ nếu bạn muốn đảm bảo sạch
        removeLocalFile(url)
        
        event.send(.back)
        
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
    
    private func removeLocalFile(_ url: URL) {
        guard url.isFileURL else { return }
        
        let path = url.path
        
        guard FileManager.default.fileExists(atPath: path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(at: url)
            print("🗑️ Removed local file:", url)
        } catch {
            print("⚠️ Failed to remove file:", error)
        }
    }
    
    
    
    
    enum SaveState {
        case idle
        case saving
        case saved
        case failed
    }
}
