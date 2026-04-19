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
        case .dashboard:
            DashboardView()
        case .paywall:
            PaywallView(onClose: {
                withAnimation {
                    router.route = .dashboard
                }
            })
        }
    }
}
