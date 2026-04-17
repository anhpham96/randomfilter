//
//  AppRouter.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import Combine
import SwiftUI

final class AppRouter: ObservableObject {
    
    @Published var route: AppRoute = .splash
    @AppStorage("isFirstTimeOpened") var isFirstTimeOpened: Bool = true

    func getRouteAfterSplash() -> AppRoute {
        isFirstTimeOpened = true
        if isFirstTimeOpened {
            return .onboarding
        } else {
            return .home
        }
    }
    
    func finishOnboarding() {
        isFirstTimeOpened = false
        route = .paywall
    }
}
