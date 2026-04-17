//
//  OnboardingStepView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//


import SwiftUI

struct OnboardingStepView: View {

    let step: OnboardingStep

    var body: some View {
        VStack(spacing: 0) {
            topStack
            introduceTextView
        }
    }
}

private extension OnboardingStepView {

    var topStack: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                OnboardingScreenShotView(step: step)
                topStackBlurView
                topStackBottomView
            }
            .clipped()
            decoratorItemsLayerView
        }.background(
            topStackBackgroundView
        )
        
    }
    
    var decoratorItemsLayerView: some View {
        
        ZStack(alignment: .center) {
            ForEach(step.decoratorItems, id: \.id) { item in
                switch item.type {
                case .image(let image, let size):
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .whiteGlow()
                        .offset(x: item.offset.x, y: item.offset.y)
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
                        .offset(x: item.offset.x, y: item.offset.y)
                    }
                }
        }
       
        
    }

    var introduceTextView: some View {
        Text(step.introduceText)
            .font(.quickSand(18))
            .bold()
            .multilineTextAlignment(.center)
            .lineSpacing(7.2)
            .padding(.horizontal, 24)
            .lineLimit(2)
    }

    var topStackBackgroundView: some View {
        Image(.onboardingBackground)
            .resizable()
            .scaledToFill()
            .luminanceToAlpha()
            .colorInvert()
            .rotationEffect(.degrees(step.rotationBackground))
            .background(
                RadialGradient(
                    colors: [
                        Color.backgroundPrimary,
                        Color.backgroundSecondary
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 400
                )
            )
    }

    var topStackBlurView: some View {
        LinearGradient(
            colors: [
                .clear,
                Color.white.opacity(0.3),
                Color.white
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 200)
    }

    @ViewBuilder
    var topStackBottomView: some View {
        switch step {
        case .one:
            SlotMachineView()
        case .two:
            OnboardingCarBoxView()
        case .three:
            SocialMediaBoxView()
        }
    }
}

#Preview {
    OnboardingStepView(step: .three)
}
