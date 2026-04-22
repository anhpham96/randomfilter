//
//  NativeAdContainer.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 21/4/26.
//

import SwiftUI
import GoogleMobileAds

struct NativeAdContainer<ViewType: UIView>: UIViewRepresentable where ViewType: NativeAdConfigurable {

    let nativeAd: NativeAd

    init(nativeAd: NativeAd) {
        self.nativeAd = nativeAd
    }

    func makeUIView(context: Context) -> ViewType {
        ViewType()
    }

    func updateUIView(_ uiView: ViewType, context: Context) {
        uiView.configure(with: nativeAd)
    }
}
