//
//  SlotMachine.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

struct SlotMachineView: View {
    
    var outfitItems: [[String]] = stride(from: 1, through: 12, by: 3).map { start in
        (start..<(start + 3)).map { "onboarding.outfit.\($0)" }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<outfitItems.count, id: \.self) { index in
                SlotMachineCollumnView(
                    items: outfitItems[index],
                    direction: index.isMultiple(of: 2) ? .up : .down
                )
            }
        }
        .background {
            leverView
        }
        
    }
    
    var leverView: some View {
        Image(.onboardingMachineLever)
            .resizable()
            .scaledToFill()
            .frame(width: 95, height: 194)
            .mask {
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .white, location: 0.75),
                        .init(color: .white, location: 1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ).mask {
                    LinearGradient(
                        stops: [
                            .init(color: .white, location: 0),
                            .init(color: .white, location: 0.75),
                            .init(color: .clear, location: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
            .topAlignment()
            .trailingAlignment()
            
            .offset(x: 40, y: -70)
    }
}

#Preview {
    SlotMachineView()
}
