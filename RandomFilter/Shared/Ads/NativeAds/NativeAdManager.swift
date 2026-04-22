//
//  NativeAdManager.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 21/4/26.
//


import GoogleMobileAds
import Combine

final class NativeAdManager: NSObject, ObservableObject {
    
    @Published var adViewModel: NativeAdViewModel?
    
    private var adLoader: AdLoader?
    
    func load() {
        adLoader = AdLoader(
            adUnitID: EnvironmentApp.nativeUnitID,
            rootViewController: nil,
            adTypes: [.native],
            options: nil
        )
        
        adLoader?.delegate = self
        adLoader?.load(Request())
    }
    
    func removeAd() {
        self.adViewModel = nil
    }
}

extension NativeAdManager: NativeAdLoaderDelegate {
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        print("❌ Native Ad load fail:", error)
    }
    
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        print("didReceive Ads")

        self.adViewModel = NativeAdViewModel(ad: nativeAd)
    }
}
