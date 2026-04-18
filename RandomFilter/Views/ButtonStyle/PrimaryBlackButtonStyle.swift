//
//  PrimaryBlackButtonStyle.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

struct PrimaryBlackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .bold()
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryBlackButtonStyle {
    static var primaryBlack: PrimaryBlackButtonStyle { .init() }
}
