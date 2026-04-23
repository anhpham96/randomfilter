//
//  OnboardingDecoratorItemView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 22/4/26.
//

import SwiftUI

struct OnboardingDecoratorItemView: View {
    
    let item: OnboardingDecoratorItem
    @State private var isAnimating = false
    
    var body: some View {
        content
            .scaleEffect(isAnimating ? 1.05 : 0.95)
            .offset(x: item.offset.x, y: item.offset.y)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true)
                ) {
                    isAnimating = true
                }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch item.type {
        case .image(let image, let size):
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .whiteGlow()
            
        case .text(let text):
            Text(text)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .font(.racingSansOne(24))
                .bold()
                .foregroundColor(.backgroundPrimary)
                .whiteGlow()
                .shadow(color: .white, radius: 10)
                .rotationEffect(item.rotation)
        }
    }
}
