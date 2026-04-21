//
//  DashboardView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct DashboardView: View {
    
    @StateObject var navigationState = NavigationState()
    
    var body: some View {
        NavigationStack(path: $navigationState.routes) {
            HomeView()
                .navigationDestination(for: DashboardRoute.self) { route in
                    switch route {
                    case .result(let url):
                        ResultView(viewModel: ResultViewModel(url: url))
                    }
                }
        }.environmentObject(navigationState)
    }
}

#Preview {
    DashboardView()
}
