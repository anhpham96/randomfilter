//
//  PaywallBenefit.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 18/4/26.
//

import Foundation

struct PaywallBenefit: Identifiable {
    let id: UUID = UUID()
    let title: String
    var isFreeAvailable: Bool = false
    var isPremiumAvailable: Bool = true
}


extension PaywallBenefit {
    static let items: [PaywallBenefit] = [
        .init(title: "Remove Ads"),
        .init(title: "Record with random filters", isFreeAvailable: true),
        .init(title: "Unlock all trending filters"),
        .init(title: "Record without use limit"),
        .init(title: "Unlock all features")
    ]
}
