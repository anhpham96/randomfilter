//
//  NativeAdConfigurable.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 21/4/26.
//

import UIKit
import GoogleMobileAds

protocol NativeAdConfigurable where Self: UIView {
    func configure(with nativeAd: NativeAd)
}
