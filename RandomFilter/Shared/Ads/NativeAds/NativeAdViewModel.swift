//
//  NativeAdViewModel.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 21/4/26.
//


import GoogleMobileAds

struct NativeAdViewModel {
    let nativeAd: NativeAd
    
    let headline: String
    let body: String?
    let icon: UIImage?
    let image: UIImage?
    let callToAction: String?
}


extension NativeAdViewModel {
    init(ad: NativeAd) {
        self.nativeAd = ad
        
        self.headline = ad.headline ?? ""
        self.body = ad.body
        self.icon = ad.icon?.image
        self.image = ad.images?.first?.image
        self.callToAction = ad.callToAction
    }
}
