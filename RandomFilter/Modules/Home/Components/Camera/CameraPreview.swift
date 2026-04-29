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
    let viewModel: HomeViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        
        view.layer.addSublayer(previewLayer)
        
        // Add pinch gesture for zoom
        let pinchGesture = UIPinchGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePinch(_:))
        )
        view.addGestureRecognizer(pinchGesture)
        
        context.coordinator.previewLayer = previewLayer
        context.coordinator.viewModel = viewModel

        
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
        var viewModel: HomeViewModel?
        var lastZoomFactor: CGFloat = 1.0
        
        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard let viewModel = viewModel else { return }
            
            switch gesture.state {
            case .began:
                lastZoomFactor = viewModel.zoomFactor
                
            case .changed:
                let newZoom = lastZoomFactor * gesture.scale
                Task {
                    await viewModel.zoom(factor: newZoom)
                }
                
            default:
                break
            }
        }
    }
}
