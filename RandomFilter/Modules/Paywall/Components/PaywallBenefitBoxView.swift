//
//  PaywallBenefitBoxView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 18/4/26.
//

import SwiftUI

struct PaywallBenefitBoxView: View {
    
    private let columns = [
        GridItem(.flexible(), alignment: .leading), // rộng hơn
        GridItem(.fixed(50), alignment: .center),
        GridItem(.fixed(60), alignment: .center)
    ]
    var body: some View {
        VStack {
            titleView
            boxView
        }
    }
    
    var titleView: some View {
        Text(Str.title)
            .font(.racingSansOne(20))
    }
    
    var boxView: some View {
        return LazyVGrid(columns: columns, spacing: 0) {

            // Header
            Text("")
            Text(Str.freeText)
                .font(.quickSandBold(14))
            Image(.paywallPremiumBadge)

            // Rows
            ForEach(PaywallBenefit.items) { item in
                Text(item.title)
                    .font(.quickSandBold(14))
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .padding(.vertical, 10)
                PaywallBenefitCheckView(isAvailable: item.isFreeAvailable)
                PaywallBenefitCheckView(isAvailable: item.isPremiumAvailable)
            }
        }
        .padding(.horizontal, 15)
        .shadowBorder()
        
        .padding(.horizontal, 16)
        
    }
    
    
}

private extension PaywallBenefitBoxView {
    enum Str {
        static let title = "Premium Benefits"
        static let freeText = "Free"

    }
}

#Preview {
    PaywallBenefitBoxView()
}
