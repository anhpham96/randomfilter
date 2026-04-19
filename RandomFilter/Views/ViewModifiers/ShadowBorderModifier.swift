//
//  CardStyleModifier.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 18/4/26.
//

import SwiftUI

struct ShadowBorderModifier: ViewModifier {
    var cornerRadius: CGFloat
    var strokeColor: Color
    var lineWidth: CGFloat
    var backgroundColor: Color
    var shadowColor: Color
    var shadowOffset: CGSize

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .shadow(color: shadowColor, radius: 0, x: shadowOffset.width, y: shadowOffset.height)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, lineWidth: lineWidth)
            )
    }
}


extension View {
    func shadowBorder(
        cornerRadius: CGFloat = 20,
        strokeColor: Color = Color.backgroundPrimary500,
        lineWidth: CGFloat = 2,
        backgroundColor: Color = .white,
        shadowColor: Color = .purplePrimary,
        shadowOffset: CGSize = CGSize(width: 0, height: 4)
    ) -> some View {
        self.modifier(
            ShadowBorderModifier(
                cornerRadius: cornerRadius,
                strokeColor: strokeColor,
                lineWidth: lineWidth,
                backgroundColor: backgroundColor,
                shadowColor: shadowColor,
                shadowOffset: shadowOffset
            )
        )
    }
}
