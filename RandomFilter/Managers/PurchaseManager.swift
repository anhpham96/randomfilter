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
}
