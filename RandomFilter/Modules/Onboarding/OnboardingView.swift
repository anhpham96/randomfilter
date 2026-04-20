//
//  OnboardingView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject var viewModel = OnboardingViewModel()
    
    @EnvironmentObject var appRouter: AppRouter
    
    var body: some View {
        content
            .onReceive(viewModel.event, perform: handleEvent)

    }
    
    var content: some View {
        VStack(spacing: 0) {
            TabView(selection: $viewModel.onboardingStep) {
                ForEach(OnboardingStep.allCases) { step in
                    OnboardingStepView(step: step)
                        .ignoresSafeArea()
                        .tag(step)
                    }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            nextStack
            Spacer()
            continueButton
        }
        .verticalScroll()
        .ignoresSafeArea(edges: .top)
    }
}


private extension OnboardingView {
  
    var nextStack: some View {
        OnboardingNextView(viewModel: viewModel)
        .padding(.horizontal, 24)
    }
    
    var continueButton: some View {
        Button("Continue"){
            viewModel.tapOnContinueButton()
        }
        .buttonStyle(.primaryBlack)
        .padding(.horizontal, 24)

    }
    
}

private extension OnboardingView {
    private func handleEvent(_ event: OnboardingEvent) {
        switch event {
        case .navigateToPaywall:
            withAnimation {
                appRouter.finishOnboarding()
            }
        }
    }
    
   
}

#Preview {
    OnboardingView()
}
