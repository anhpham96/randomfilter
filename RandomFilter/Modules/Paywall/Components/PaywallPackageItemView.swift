//
//  PackageItemView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 18/4/26.
//

import SwiftUI

struct PaywallPackageItemView: View {
    
    let item: PaywallPackageItem
    var selectedItem: PaywallPackageItem?
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Text(item.displayName)
                    .font(.quickSand(displayTextSize))
                    .bold()
                    .foregroundColor(titleColor)
                Text(item.price.currencyFormat())
                    .font(.quickSand(priceTextSize))
                    .bold()
                if let weeklyPrice = item.weeklyPrice {
                    Text("\(weeklyPrice.currencyFormat())/week")
                        .font(.quickSand(10))
                        .bold()
                        .foregroundColor(titleColor)
                } else {
                    Spacer()
                        .frame(height: 20)
                }
            }
            Spacer()
        }
        .padding(.vertical, vPaddingSize)
        .applyIf(!item.isBestOffer, transform: { view in
            view
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.purplePrimary,lineWidth: 2)
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.purpleSecondary)
                )
        })
        .applyIf(item.isBestOffer) { view in
            view
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.backgroundPrimary300)
                )
                .shadowBorder(shadowOffset: CGSize(width: 0, height: 10))
                .overlay {
                    Text("Best Offer")
                        .font(.quickSand(12))
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.purplePrimary)
                        .cornerRadius(18)
                        .topAlignment()
                        .offset(y: -10)
                }
        }
        .overlay {
            if item.id == selectedItem?.id {
                Image(.paywallSelectIcon)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .topAlignment()
                    .trailingAlignment()
                    .padding(.horizontal, 5)
                    .padding(.vertical, 15)

            }
        }
    }
    
    var titleColor: Color {
        return item.isBestOffer ? .textLightBlack : .purplePrimary

    }
    
    var vPaddingSize: CGFloat {
        return item.isBestOffer ? 20 : 16

    }
    
    var hPaddingSize: CGFloat {
        return item.isBestOffer ? 16 : 12

    }
    
    var displayTextSize: CGFloat {
        return item.isBestOffer ? 16 : 14

    }
    
    var priceTextSize: CGFloat {
        return item.isBestOffer ? 28 : 16
    }
}

#Preview {
    HStack {
        PaywallPackageItemView(item: .init(id: "A", displayName: "Yearly", price: 19.99, weeklyPrice: 0.38), selectedItem: .init(id: "A", displayName: "", price: 0))
        PaywallPackageItemView(item: .init(id: "A", displayName: "Weekly", price: 3.99, isBestOffer: true), selectedItem: .init(id: "A", displayName: "", price: 0))
        PaywallPackageItemView(item: .init(id: "A", displayName: "Montly", price: 5.99, weeklyPrice: 1.49), selectedItem: .init(id: "A", displayName: "", price: 0))
    }
}
