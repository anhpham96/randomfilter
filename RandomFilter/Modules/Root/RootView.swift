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
            Text("Home")
        case .paywall:
            PaywallView(onClose: {
                print("Close")
                withAnimation {
                    router.route = .dashboard
                }
            })
        }
    }
}
