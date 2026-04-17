//
//  OnboardingViewModel.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import Foundation
import Combine
import SwiftUI

class OnboardingViewModel: BaseViewModel {
    @Published var onboardingStep: OnboardingStep = .one
        
    let event = PassthroughSubject<OnboardingEvent, Never>()
    
    func tapOnNextButton() {
        withAnimation {
            if let next = onboardingStep.next {
                onboardingStep = next
            }
        }
    }
    
    func tapOnContinueButton() {
        event.send(.navigateToPaywall)
    }
}
