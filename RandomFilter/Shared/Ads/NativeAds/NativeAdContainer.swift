//
//  NativeAdContainer.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 21/4/26.
//


import SwiftUI
import GoogleMobileAds

struct NativeAdContainer: UIViewRepresentable {

    let nativeAd: NativeAd

    func makeUIView(context: Context) -> MediumNativeAdView {
        MediumNativeAdView()
    }

    func updateUIView(_ uiView: MediumNativeAdView, context: Context) {
        uiView.configure(with: nativeAd)
    }
}
