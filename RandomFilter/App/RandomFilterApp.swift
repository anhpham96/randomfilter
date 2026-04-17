//
//  RandomFilterApp.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 16/4/26.
//

import SwiftUI

@main
struct RandomFilterApp: App {
    
    @StateObject private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
        }
    }
}
