//
//  ViewModelFactory.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 22/4/26.
//

import Foundation


protocol ViewModelFactoryType {
    func makeOnboarding() -> OnboardingViewModel
    func makePaywall() -> PaywallViewModel
    func makeHome() -> HomeViewModel
    func makeResult(url: URL) -> ResultViewModel
    
}

struct ViewModelFactory: ViewModelFactoryType {

    func makeOnboarding() -> OnboardingViewModel {
        OnboardingViewModel()
    }

    func makePaywall() -> PaywallViewModel {
        PaywallViewModel()
    }
    
    func makeHome() -> HomeViewModel {
            HomeViewModel()
    }

    func makeResult(url: URL) -> ResultViewModel {
        ResultViewModel(url: url)
    }
}
