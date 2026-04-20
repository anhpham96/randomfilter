//
//  CameraPreview.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//


import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update layer frame when view size changes
        if let previewLayer = context.coordinator.previewLayer {
            DispatchQueue.main.async {
                previewLayer.frame = uiView.bounds
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var previewLayer: AVCaptureVideoPreviewLayer?
        var cameraManager: CameraManager?
        var lastZoomFactor: CGFloat = 1.0
        
//        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
//            guard let manager = cameraManager else { return }
//            
//            switch gesture.state {
//            case .began:
//                //lastZoomFactor = manager.zoomFactor
//                
//            case .changed:
//                let newZoom = lastZoomFactor * gesture.scale
//                manager.zoom(factor: newZoom)
//                
//            default:
//                break
//            }
//        }
    }
}
