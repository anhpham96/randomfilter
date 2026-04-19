//
//  HomeView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var camera = CameraManager()
    
    var body: some View {
        ZStack {
            
            // Camera preview
            CameraPreview(session: camera.session)
                .ignoresSafeArea()
            
            // UI overlay
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        camera.switchCamera()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                Spacer()
                
                // Fake shutter button
                Button {
                    // sau này chụp ảnh ở đây
                } label: {
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 55, height: 55)
                        )
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear(perform: {
            camera.start()
        })
        .onDisappear {
            camera.stop()
        }
    }
}

#Preview {
    DashboardView()
}
