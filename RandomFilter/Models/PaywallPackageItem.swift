//
//  PaywallPackageItem.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 18/4/26.
//


struct PaywallPackageItem: Identifiable {
    let id: String
    let displayName: String
    let price: Double
    var weeklyPrice: Double? = nil
    var isBestOffer: Bool = false
}
