//
//  HomeControlsView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct HomeControlsView: View {
    
    @ObservedObject var cameraManager: CameraManager
    
    
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
            
            durationStack
            
            ZStack {
                RecordButton(isRecording: cameraManager.isRecording) {
                    cameraManager.isRecording ?
                    cameraManager.stopRecord() :
                    cameraManager.startRecord()
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
        let systemName = cameraManager.isTorchOn ? "bolt.fill" : "bolt.slash.fill"
        CameraControlButton(systemName: systemName, action: {
           // cameraManager.toggleTorch()
        })
    }
    
    var switchCameraButton: some View {
        CameraControlButton(systemName: "arrow.triangle.2.circlepath", action: {
            //cameraManager.switchCamera()
        })
    }
    
    var durationStack: some View {
        HStack(spacing: 8) {
            ForEach(cameraManager.durationValues, id: \.self) { value in
               DurationView(value: value, isSelected: isDurationSelected(value))
                    .onTapGesture {
                        withAnimation {
                            cameraManager.selectedDuration = value
                        }
                    }
            }
        }
        .frame(height: 50)
    }
}

private extension HomeControlsView {
    func isDurationSelected(_ value: Float) -> Bool {
        return cameraManager.selectedDuration == value
    }
}

#Preview {
    HomeControlsView(cameraManager: CameraManager())
        .background(
            
            Image(.onboardingScreenshotTwo)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
}
