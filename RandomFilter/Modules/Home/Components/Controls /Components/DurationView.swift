//
//  DurationView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import SwiftUI

struct DurationView: View {
    
    let value: Double
    let isSelected: Bool
    
    var body: some View {
        Text("\(Int(value))s")
            .font(.quickSand(16))
            .foregroundColor(.white)
            .bold()
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .applyIf(isSelected, transform: { view in
                view
                .background(Color.black.opacity(0.5))
                .cornerRadius(37)
            })
    }
}

#Preview {
    DurationView(value: 12, isSelected: true)
}
