//
//  PurchaseManager.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import Combine
import SwiftUI

final class PurchaseManager: ObservableObject {
    @AppStorage("purchasedPackage") var purchasedPackage: String = ""
    
    var isPremium: Bool {
        !purchasedPackage.isEmpty
    }
    
    
    func getPackages() -> [PaywallPackageItem] {
        return [
            .init(id: "filtercamera.premium.yearly", displayName: "Yearly", price: 19.99, weeklyPrice: 19.99/12),
            .init(id: "filtercamera.premium.weekly", displayName: "Weekly", price: 3.99, isBestOffer: true),
            .init(id: "filtercamera.premium.monthly", displayName: "Monthly", price: 5.99, weeklyPrice: 5.99/12),
        ]
    }
    
    func updatePackage(_ package: PaywallPackageItem) {
        purchasedPackage = package.id
    }
}
