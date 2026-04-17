//
//  RootView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        switch router.route {
        case .splash:
            SplashView()
        case .onboarding:
            OnboardingView()
        case .home:
            Text("Home")
        case .paywall:
            Text("Paywall")
        }
    }
}
