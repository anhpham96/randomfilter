//
//  SlotMachineItemView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

struct SlotMachineItemView: View {
    
    let imageName: String
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 50, height: 50)
            .whiteGlow()
    }
}

#Preview {
    SlotMachineItemView(imageName: "onboarding.outfit.1")
        .background(Color.black)
}
