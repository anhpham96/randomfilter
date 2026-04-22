//
//  WhiteGlowModifier.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//


import SwiftUI

struct WhiteGlowModifier: ViewModifier {
    
    var color: Color = .white
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.9), radius: 6)
            .shadow(color: color.opacity(0.6), radius: 14)
            .shadow(color: color.opacity(0.3), radius: 28)
    }
}

extension View {
    func whiteGlow() -> some View {
        self.modifier(WhiteGlowModifier())
    }
}