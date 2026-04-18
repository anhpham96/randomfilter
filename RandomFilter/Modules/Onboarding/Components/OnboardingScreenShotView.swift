//
//  OnboardingScreenShotView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

struct OnboardingScreenShotView: View {
    
    var step: OnboardingStep
    
    var body: some View {
        Image(.phoneFrame)
            .resizable()
            .scaledToFit()
            .frame(width: 245, height: 501)
            .background {
                Image(step.screenShotImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 228, height: 480)
                    .clipShape(RoundedRectangle(cornerRadius: 42))
            }
            .offset(y: 60)
    }
}

#Preview {
    OnboardingScreenShotView(step: .one)
}
