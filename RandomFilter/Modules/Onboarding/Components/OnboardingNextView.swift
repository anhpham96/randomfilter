//
//  OnboardingNextView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

struct OnboardingNextView: View {

    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        HStack {
            onboardingStepStatusView
            Spacer()
            nextButton
        }.frame(minHeight: 40)
    }
}

private extension OnboardingNextView {
    

    var onboardingStepStatusView: some View {
        HStack(spacing: 6) {
            ForEach(OnboardingStep.allCases) { step in
                let isActive = step == viewModel.onboardingStep

                Group {
                    if isActive {
                        Capsule()
                            .frame(width: 16, height: 8)
                    } else {
                        Circle()
                            .frame(width: 8, height: 8)
                    }
                }
                .foregroundStyle(isActive ? Color.surface : Color.neutral)
                .animation(.spring(response: 0.3, dampingFraction: 0.8),
                           value: viewModel.onboardingStep)
            }
        }
    }

    var nextButton: some View {
        Group {
            if viewModel.onboardingStep.next != nil {
                Button {
                    viewModel.tapOnNextButton()
                } label: {
                    Text(Str.nextText)
                        .bold()
                        .foregroundColor(Color.backgroundPrimary)
                }
            } else {
                
            }
        }
    }
}


private extension OnboardingNextView {
    enum Str {
        static let nextText = "Next"

    }
}


#Preview {
    OnboardingNextView(viewModel: OnboardingViewModel())
}
