//
//  ArrowView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

struct OnboardingArrowView: View {
    @State private var moveUp = false

    var body: some View {
        Image(.carSelectorArrow)
            .resizable()
            .frame(width: 33, height: 33)
            .offset(y: moveUp ? -5 : 5) // lên xuống
            .animation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true),
                value: moveUp
            )
            .onAppear {
                moveUp.toggle()
            }
    }
}
