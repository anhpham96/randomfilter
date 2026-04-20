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
            CameraView(viewModel: viewModel)
            HomeControlsView(viewModel: viewModel)
            
            if viewModel.permissionState == .denied {
                PermissionDeniedView()
            }
        }
        .onAppear {
            Task {
                await viewModel.prepareCamera()
            }
        }
        .sheet(isPresented: $viewModel.showPreview) {
            if let url = viewModel.recordedURL {
                VideoPreviewView(url: url)
            }
        }
    }
    
}

#Preview {
    DashboardView()
}
