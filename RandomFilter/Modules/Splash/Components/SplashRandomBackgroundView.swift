//
//  SplashRandomBackgroundView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

struct SplashRandomBackgroundView: View {
    
    @State private var isRandomBackgroundVisible = false
    
    var body: some View {
        Image(.randomMask)
            .resizable()
            .opacity(isRandomBackgroundVisible ? 1 : 0.5)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: true)
                ) {
                    isRandomBackgroundVisible.toggle()
                }
            }
    }
}

#Preview {
    SplashRandomBackgroundView()
}
