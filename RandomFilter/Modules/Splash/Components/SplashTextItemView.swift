//
//  SplashTextItemView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

struct SplashTextItemView: View {
    
    let text: String
    @State private var isVisible = false
    
    var body: some View {
        Text(text)
        .font(.custom("Oswald", size: 14))
        .bold()
        .foregroundColor(.textDark)
        .padding(10)
        .background(Color.blueSecondary)
        .cornerRadius(40)
        .rotationEffect(.degrees(-29.23))
        .scaleEffect(isVisible ? 1 : 0)
        .animation(.spring(duration: 2), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }
}

#Preview {
    SplashTextItemView(text: "Random")
}
