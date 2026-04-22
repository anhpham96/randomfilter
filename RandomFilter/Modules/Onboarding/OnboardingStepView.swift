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
                .padding(.vertical, 20)
            Spacer()
        }
    }
}

private extension OnboardingStepView {

    var topStack: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .bottom) {
                topStackBackgroundView
                    .frame(height: 500)
                OnboardingScreenShotView(step: step)
                topStackBlurView
                topStackBottomView
            }
            decoratorItemsLayerView
        }.background(
            
        )
        
    }
    
    var decoratorItemsLayerView: some View {
        
        ZStack(alignment: .center) {
            ForEach(step.decoratorItems, id: \.id) { item in
                OnboardingDecoratorItemView(item: item)
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
            .frame(height: 100)
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
            ).ignoresSafeArea()
        
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
