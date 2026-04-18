//
//  CarBoxView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//


import SwiftUI

struct OnboardingCarBoxView: View {
    let items = (1...3).map { "onboarding.car.\($0)" }

    @State private var selectedIndex = 1

    var body: some View {
        VStack {
            arrowView
            carsStack
            .background(.ultraThinMaterial.opacity(0.6))
        }
        
    }
    
    var carsStack: some View {
        ZStack {
            ForEach(items.indices, id: \.self) { index in
                let offsetIndex = index - selectedIndex
                let xOffset: CGFloat = CGFloat(offsetIndex) * 150
                let scale: CGFloat = offsetIndex == 0 ? 0.9 : 0.4
                Image(items[index])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                    .scaleEffect(scale)
                    .offset(x: xOffset)
                    .zIndex(offsetIndex == 0 ? 1 : 0)
                    .animation(.spring(response: 0.35, dampingFraction: 0.75), value: selectedIndex)
                    .onTapGesture {
                        selectedIndex = index
                    }
            }
        }
        .frame(maxWidth: .infinity) // 👈 full ngang
        .frame(height: 140)
    }
    
    var arrowView: some View {
        OnboardingArrowView()
    }
}

#Preview {
    VStack {
        Spacer()
        OnboardingCarBoxView()
        Spacer()
    }
    .background(Color.blue)
}
