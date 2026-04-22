//
//  CarItemView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 18/4/26.
//

import SwiftUI

struct OnboardingCarItemView: View {
    let imageName: String
    let isSelected: Bool
    let offsetIndex: Int
    let onTap: () -> Void

    var body: some View {
        let xOffset: CGFloat = CGFloat(offsetIndex) * 150
        let scale: CGFloat = isSelected ? 0.9 : 0.4

        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 100)
            .scaleEffect(scale)
            .offset(x: xOffset)
            .zIndex(isSelected ? 1 : 0)
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isSelected)
            .onTapGesture {
                onTap()
            }
    }
}
