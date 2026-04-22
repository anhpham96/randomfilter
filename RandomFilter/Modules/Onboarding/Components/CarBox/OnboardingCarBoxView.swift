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
                OnboardingCarItemView(imageName: items[index],
                            isSelected: index == selectedIndex,
                            offsetIndex: index - selectedIndex) {
                    selectedIndex = index
                }
            }
        }
        .frame(maxWidth: .infinity)
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
