//
//  PaywallButtonStyle.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//
import SwiftUI

struct PaywallButtonStyle: ButtonStyle {
    var isLoading: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(isLoading ? 0 : 1)
            .overlay {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .bold()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.orangeBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.orangeBorder, lineWidth: 2)
                    )
                    .shadow(
                        color: Color.orangeBorder.opacity(0.5),
                        radius: configuration.isPressed ? 2 : 6,
                        y: configuration.isPressed ? 2 : 6
                    )
            )
            .scaleEffect(configuration.isPressed && !isLoading ? 0.97 : 1)
            .brightness(configuration.isPressed && !isLoading ? -0.05 : 0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PaywallButtonStyle {
    static func paywall(isLoading: Bool = false) -> PaywallButtonStyle {
        .init(isLoading: isLoading)
    }
}
