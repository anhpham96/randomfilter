//
//  SocialMediaBoxView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

struct SocialMediaBoxView: View {
    var body: some View {
        HStack(spacing: 12) {
            ForEach(OnboardingSocialMediaType.allCases, id: \.rawValue) { type in
                SocialMediaItemView(type: type)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
                .shadow(color: .backgroundPrimary, radius: 0, x: 4, y: 6)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.purplePrimary, lineWidth: 3)
        }
        .padding(.vertical, 20)
    }
}
#Preview {
    SocialMediaBoxView()
}
