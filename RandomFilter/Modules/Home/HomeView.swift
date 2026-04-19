//
//  HomeView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct HomeView: View {
        
    @StateObject var cameraManager: CameraManager = CameraManager()
    
    var body: some View {
        ZStack {
            CameraView(camera: cameraManager)
            HomeControlsView(cameraManager: cameraManager)
        }
            
            
    }
}

#Preview {
    DashboardView()
}
