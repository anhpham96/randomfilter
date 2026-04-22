//
//  PermissionDeniedView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 20/4/26.
//

import SwiftUI

struct PermissionDeniedView: View {
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(spacing: 16) {
            
            Image(systemName: "camera.fill")
                .font(.system(size: 28))
            
            Text(Str.title)
                .font(.headline)
            
            Text(Str.message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.7))
            
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    openURL(url)
                }
            } label: {
                Text(Str.openSettings)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(.black.opacity(0.75))
        .foregroundColor(.white)
        .cornerRadius(16)
        .padding(.horizontal, 24)
    }
}

private extension PermissionDeniedView {
    enum Str {
        static let title = "Camera permission required"
        static let message = "Please enable Camera & Microphone in Settings"
        static let openSettings = "Open Settings"
    }
}
