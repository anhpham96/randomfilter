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
    @EnvironmentObject var nativeAdManager: NativeAdManager

    var body: some View {
       content
            .opacity(viewModel.isCountingDown ? 0 : 1)
            .overlay(content: {
                if viewModel.isCountingDown {
                    CountdownTextView(seconds: viewModel.countdownSeconds)
                }
               
            })
            .onAppear {
                loadAd()
            }
            .onDisappear {
                removeAd()
            }

    }
    
    
    var content: some View {
        VStack {
            VStack {
                adsView
                VStack {
                    premiumButton
                    
                    if viewModel.hasTorch {
                        flashButton
                    }
                    
                    if !viewModel.isRecording {
                        switchCameraButton
                        countdownButton
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
                    viewModel.tapOnRecordingButton()
                }
                
            }
        }
    }
    
    
    
}

private extension HomeControlsView {
    
    @ViewBuilder
    var adsView: some View {
        if !purchaseManager.isPremium, let ad = nativeAdManager.adViewModel {
            NativeAdContainer<MediumNativeAdView>(nativeAd: ad.nativeAd)
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
    
    var countdownButton: some View {
        CameraControlButton(
            systemName: "timer",
            action: {
                viewModel.isCountdownOn.toggle()
            }
        )
        .overlay(alignment: .bottomTrailing) {
            if viewModel.isCountdownOn {
                Text("\(viewModel.limitTimer)")
                    .foregroundColor(.white)
                    .font(.quickSand(12))
                    .bold()
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
            }
        }
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
        nativeAdManager.load()
    }
    
    func removeAd() {
        guard !purchaseManager.isPremium else { return }
        nativeAdManager.removeAd()
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
