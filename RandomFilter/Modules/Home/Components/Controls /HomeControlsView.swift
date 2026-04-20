//
//  HomeControlsView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct HomeControlsView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    
    var body: some View {
        VStack {
            VStack {
                premiumButton
                flashButton
                switchCameraButton
            }
            .trailingAlignment()
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
                
                HStack {
                    Text("Filter")
                    Spacer()
                    
                }
                .padding(.horizontal, 25)
            }
        }
    }
    
    
    
    
}

private extension HomeControlsView {
    
    var premiumButton: some View {
        CameraControlButton(systemName: "crown.fill", action: {
           // cameraManager.toggleTorch()
        })
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
            viewModel.switchCamera()
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
    func isDurationSelected(_ value: Float) -> Bool {
        return viewModel.selectedDuration == value
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
}
