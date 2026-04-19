//
//  RandomFilterApp.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 16/4/26.
//

import SwiftUI

@main
struct RandomFilterApp: App {
    
    @StateObject private var purchaseManager = PurchaseManager()
    @StateObject private var router: AppRouter

    init() {
        let pm = PurchaseManager()
        _purchaseManager = StateObject(wrappedValue: pm)
        _router = StateObject(wrappedValue: AppRouter(purchaseManager: pm))
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
                .environmentObject(purchaseManager)
        }
    }
}
