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
            .shadowBorder(strokeColor: .orangeBorder,
                          backgroundColor: .orangeBackground,
                          shadowColor: Color.orangeBorder,
                          shadowOffset: configuration.isPressed ? .zero : .init(width: 0, height: 4))
            .offset(y: configuration.isPressed ? 4 : 0)

            .brightness(configuration.isPressed && !isLoading ? -0.05 : 0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PaywallButtonStyle {
    static func paywall(isLoading: Bool = false) -> PaywallButtonStyle {
        .init(isLoading: isLoading)
    }
}

//
//    .background(
//        RoundedRectangle(cornerRadius: cornerRadius)
//            .fill(backgroundColor)
//            .shadow(color: shadowColor, radius: 0, x: shadowOffset.width, y: shadowOffset.height)
//    )
//    .overlay(
//        RoundedRectangle(cornerRadius: cornerRadius)
//            .stroke(strokeColor, lineWidth: lineWidth)
//    )
