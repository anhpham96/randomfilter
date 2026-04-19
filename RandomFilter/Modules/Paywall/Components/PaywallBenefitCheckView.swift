//
//  PaywallBenefitCheckView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 18/4/26.
//

import SwiftUI

struct PaywallBenefitCheckView: View {
    
    var isAvailable: Bool
    var body: some View {
        Image(isAvailable ? .paywallCheckmark : .paywallCross)
            .resizable()
            .scaledToFit()
            .frame(width: isAvailable ? 23 : 16)
        
    }
}

#Preview {
    PaywallBenefitCheckView(isAvailable: true)
}
