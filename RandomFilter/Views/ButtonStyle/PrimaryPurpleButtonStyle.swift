//
//  PrimaryPurpleButtonStyle.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 21/4/26.
//

import SwiftUI

struct PrimaryPurpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.textPurple)
            .bold()
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Color(.backgroundPrimary300)) // hoặc Color.primary300 nếu bạn custom
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryPurpleButtonStyle {
    static var primaryPurple: PrimaryPurpleButtonStyle { .init() }
}
