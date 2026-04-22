//
//  HomeView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct HomeView: View {
        
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var navigationState: NavigationState
    
    var body: some View {
        ZStack {
            content
                
            if viewModel.permissionState == .denied {
                PermissionDeniedView()
            }
        }
        .onReceive(viewModel.event, perform: handleEvent)
        .onAppear {
            Task {
                await viewModel.prepareCamera()
            }
        }
        .fullScreenCover(isPresented: $viewModel.isPaywallViewPresented) {
            PaywallView(viewModel: PaywallViewModel()) {
                viewModel.isPaywallViewPresented = false
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        CameraView(viewModel: viewModel)
        HomeControlsView(viewModel: viewModel)
    }
    
}

extension HomeView {
    private func handleEvent(_ event: HomeEvent) {
        switch event {
        case .showResult(let url):
            navigationState.routes.append(DashboardRoute.result(url: url))
        }
    }
}

#Preview {
    DashboardView(viewModelFactory: ViewModelFactory())
        .environmentObject(NavigationState())
}
