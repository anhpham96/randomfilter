//
//  PermissionDeniedView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 20/4/26.
//

import SwiftUI

struct PermissionDeniedView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Camera permission required")
                .font(.headline)
            
            Text("Please enable Camera & Microphone in Settings")
                .font(.subheadline)
                .opacity(0.7)
            
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        }
        .padding()
        .background(.black.opacity(0.6))
        .foregroundColor(.white)
        .cornerRadius(12)
    }
}
