//
//  CameraView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var camera = CameraManager()
       
    var body: some View {
        CameraPreview(session: camera.session)
            .ignoresSafeArea()
            .onAppear {
                camera.start()
            }
            .onDisappear {
                camera.stop()
            }
       }
}

#Preview {
    CameraView()
}
