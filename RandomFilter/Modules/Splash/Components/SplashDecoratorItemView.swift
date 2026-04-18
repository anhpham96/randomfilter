//
//  SplashDecoratorItemView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 16/4/26.
//

import SwiftUI

struct SplashDecoratorItemView: View {
    
    let item: SplashDecoratorItem
    
    @State private var isVisible = false
    
    var body: some View {
        Image(item.image)
            .resizable()
            .scaledToFit()
            .shadow(
                color: Color.shadow,
                radius: 0,
                x: 6,
                y: 6
            )
            .frame(
                width: item.size.width,
                height: item.size.height
            )
            .rotationEffect(.degrees(item.rotation))
            .scaleEffect(isVisible ? 1 : 0)
            .animation(.spring(duration: 2), value: isVisible)
            .onAppear {
                isVisible = true
            }

    }
}

#Preview {
    SplashDecoratorItemView(item: SplashDecoratorItem.items[0])
}
