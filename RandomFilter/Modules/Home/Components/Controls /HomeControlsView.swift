//
//  HomeControlsView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct HomeControlsView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var purchaseManager: PurchaseManager
    @StateObject var adManager = NativeAdManager()

    var body: some View {
       content
            .onAppear {
                loadAd()
            }
    }
    
    
    var content: some View {
        VStack {
            VStack {
                adsView
                VStack {
                    premiumButton
                    flashButton
                    if !viewModel.isRecording {
                        switchCameraButton
                    }
                }
                .trailingAlignment()
            }
            .padding(.horizontal, 20)
            
            Spacer()

            if !viewModel.isRecording {
                durationStack
            }
            
            ZStack {
                RecordButton(isRecording: viewModel.isRecording, progress: viewModel.progress) {
                    viewModel.isRecording ?
                    viewModel.stopRecord() :
                    viewModel.startRecord()
                }
                
            }
        }
    }
    
    
    
}

private extension HomeControlsView {
    
    @ViewBuilder
    var adsView: some View {
        if !purchaseManager.isPremium, let ad = adManager.adViewModel {
            NativeAdContainer(nativeAd: ad.nativeAd)
                .frame(height: 100)
        }
    }
    
    
    @ViewBuilder
    var premiumButton: some View {
        if purchaseManager.isPremium {
            EmptyView()
        } else {
            CameraControlButton(systemName: "crown.fill", action: {
                viewModel.isPaywallViewPresented = true
            })
        }
       
    }
    
    @ViewBuilder
    var flashButton: some View {
        let systemName = viewModel.isTorchOn ? "bolt.fill" : "bolt.slash.fill"
        CameraControlButton(systemName: systemName, action: {
            viewModel.toggleTorch()
        })
    }
    
    var switchCameraButton: some View {
        CameraControlButton(systemName: "arrow.triangle.2.circlepath", action: {
            viewModel.sessionManager.switchCamera()
        })
    }
    
    var durationStack: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.durationValues, id: \.self) { value in
               DurationView(value: value, isSelected: isDurationSelected(value))
                    .onTapGesture {
                        withAnimation {
                            viewModel.selectedDuration = value
                        }
                    }
            }
        }
        .frame(height: 50)
    }
}

private extension HomeControlsView {
    func isDurationSelected(_ value: Double) -> Bool {
        return viewModel.selectedDuration == value
    }
    
    func loadAd() {
        guard !purchaseManager.isPremium else { return }
        adManager.load()
    }
}

#Preview {
    HomeControlsView(viewModel: HomeViewModel())
        .background(
            
            Image(.onboardingScreenshotTwo)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .environmentObject(PurchaseManager())
}
