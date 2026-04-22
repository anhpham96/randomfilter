//
//  ResultView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 20/4/26.
//

import SwiftUI

struct ResultView: View {
    
    @StateObject var viewModel: ResultViewModel
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var nativeAdManager: NativeAdManager
    @EnvironmentObject var purchaseManager: PurchaseManager

    var body: some View {
        content
            .onReceive(viewModel.event, perform: handleEvent)
            .navigationBarTitle(Str.title, displayMode: .inline)
            .onDisappear {
                viewModel.removeLocalFile()
                removeAd()
            }
            .onAppear {
                loadAd()
            }
    }
    
    var content: some View {
        VStack {
            videoPreview
            
            nativeAdsView
            
            saveButton
            retryButton
            shareButton
        }
        .padding(25)
        .verticalScroll()
        .alert(isPresented: $viewModel.showErrorAlert) {
            saveFailedAlert
        }
    }
    
    var videoPreview: some View {
        VideoPreviewView(url: viewModel.url)
            .frame(width: 167, height: 167 * 16 / 9)
            .cornerRadius(14)
        
    }
    
    var saveButton: some View {
        Button {
            Task {
                await viewModel.tapSaveButton()
            }
        } label: {
            HStack {
                Image(systemName: iconName)
                Text(buttonTitle)
            }
        }
        .disabled(viewModel.state == .saving || viewModel.state == .saved)
        .buttonStyle(.primaryBlack)
    }
    
    var retryButton: some View {
        Button {
            viewModel.tapRetryButton()
        } label: {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text(Str.retry)
            }
        }
        .buttonStyle(.primaryPurple)
    }
    
    var shareButton: some View {
        ShareLink(item: viewModel.url) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text(Str.share)
            }
        }
        .buttonStyle(.primaryPurple)
    }
    
    
    @ViewBuilder
    var nativeAdsView: some View {
        if purchaseManager.isPremium {
            EmptyView()
        } else {
            Group {
                if let ad = nativeAdManager.adViewModel {
                    NativeAdContainer<LargeNativeAdView>(nativeAd: ad.nativeAd)
                } else {
                    Spacer()
                }
            }
        }
    }
    
    private var saveFailedAlert: Alert {
        Alert(
            title: Text(Str.saveFailedTitle),
            message: Text(viewModel.errorMessage),
            dismissButton: .cancel(Text(Str.ok))
        )
    }
    
    private var buttonTitle: String {
        switch viewModel.state {
        case .idle: return Str.save
        case .saving: return Str.saving
        case .saved: return Str.saved
        case .failed: return Str.save
        }
    }

    private var iconName: String {
        switch viewModel.state {
        case .idle: return "square.and.arrow.down"
        case .saving: return "clock"
        case .saved: return "checkmark"
        case .failed: return "arrow.clockwise"
        }
    }
    
}

extension ResultView {
    private func handleEvent(_ event: ResultEvent) {
        switch event {
        case .back:
            navigationState.popToRoot()
            
        }
    }
    
    func loadAd() {
        guard !purchaseManager.isPremium else { return }
        nativeAdManager.load()
    }
    
    func removeAd() {
        guard !purchaseManager.isPremium else { return }
        nativeAdManager.removeAd()
    }
}

private extension ResultView {
    enum Str {
        static let title = "Result"
        
        static let save = "Save"
        static let saving = "Saving..."
        static let saved = "Saved"
        static let retry = "Retry"
        static let share = "Share Video"
        
        static let saveFailedTitle = "Save Failed"
        static let ok = "OK"
    }
}


#Preview {
    NavigationStack {
        ResultView(viewModel: ResultViewModel(url: URL(string: "https://www.w3schools.com/html/mov_bbb.mp4")!))
    }.environmentObject(PurchaseManager())
    .environmentObject(NativeAdManager())
  
}
