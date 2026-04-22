//
//  InfinitePagerView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//


import SwiftUI

struct SlotMachineCollumnView: View {
    
    var items: [String]
    
    var direction: SlotMachineDirection = .down
    
    @State private var offsetY: CGFloat = 0
    @State private var hasStarted = false
    
    private let itemHeight: CGFloat = 50
    private let spacing: CGFloat = 20
    private let containerHeight: CGFloat = 198

    var body: some View {
        itemsStack
        .padding(10)
        .frame(height: containerHeight)
        .background(backgroundView)
        .mask {
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: .black, location: 0.3),
                    .init(color: .black, location: 0.88),
                    .init(color: .clear, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
                )
        }
        .clipped()
    }
    
    
    
    @ViewBuilder
    var itemsStack: some View {
        let totalHeight = (itemHeight + spacing) * CGFloat(items.count)
        VStack(spacing: spacing) {
            ForEach(0..<(items.count * 4), id: \.self) { index in
                SlotMachineItemView(imageName: items[index % items.count])
            }
        }
        .offset(y: offsetY)
        .clipped()
        .onAppear {
            guard !hasStarted else { return }
            hasStarted = true
            
            offsetY = direction == .up ? 0 : -totalHeight
            
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                offsetY = direction == .up ? -totalHeight : 0
            }
        }
    }
    
    var backgroundView: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(
                LinearGradient(
                    stops: [
                        
                        .init(color: Color.backgroundPrimary.opacity(0.0), location: 0.0),
                        .init(color: Color.backgroundPrimary.opacity(0.7), location: 0.25),
                        .init(color: Color.backgroundPrimary.opacity(0.8), location: 0.5),
                        .init(color: Color.backgroundPrimary.opacity(0.7), location: 0.75),
                        .init(color: Color.backgroundPrimary.opacity(0.0), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .background(.ultraThinMaterial)
            .blur(radius: 3.3)
    }
}



#Preview {
    VStack {
        Spacer()
        HStack {
            SlotMachineCollumnView(items: [], direction: .up)
        }
        Spacer()
    }
    
}
