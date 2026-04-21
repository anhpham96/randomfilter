//
//  CameraView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct CameraView: View {
    @ObservedObject var viewModel: HomeViewModel
       
    var body: some View {
        CameraPreview(session: viewModel.sessionManager.session, viewModel: viewModel)
            .ignoresSafeArea()
            .onAppear {
                viewModel.start()
            }
            .onDisappear {
                viewModel.stop()
            }
          
       }
}

#Preview {
    CameraView(viewModel: HomeViewModel())
}
