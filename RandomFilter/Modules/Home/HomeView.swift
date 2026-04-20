//
//  HomeView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct HomeView: View {
        
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
        
    var body: some View {
        ZStack {
            content
                
            if viewModel.permissionState == .denied {
                PermissionDeniedView()
            }
        }
        .onAppear {
            Task {
                await viewModel.prepareCamera()
            }
        }
        .fullScreenCover(isPresented: $viewModel.isPaywallViewPresented) {
            PaywallView {
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

#Preview {
    DashboardView()
}
