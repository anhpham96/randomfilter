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
    
    private let purchaseManager: PurchaseManager
    
    init(purchaseManager: PurchaseManager) {
        self.purchaseManager = purchaseManager
    }
    
    func getRouteAfterSplash() -> AppRoute {
        if isFirstTimeOpened {
            return .onboarding
        } else {
            return purchaseManager.isPremium ? .dashboard : .paywall
            
        }
    }
    
    func finishOnboarding() {
        isFirstTimeOpened = false
        route = .paywall
    }
    
    func navigateToDashboard() {
        route = .dashboard
    }
}
