//
//  SocialMediaItemView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

enum OnboardingSocialMediaType: String, CaseIterable {
    case tiktok
    case instagram
    case facebook
    case messenger
    case share
    
    var displayText: String {
        rawValue.capitalized
    }
    
    var image: ImageResource {
        return ImageResource(name: "ic_\(rawValue)", bundle: .main)
    }
}


struct SocialMediaItemView: View {
    
    let type: OnboardingSocialMediaType
    var body: some View {
        VStack(alignment:.center) {
            Image(type.image)
                .resizable()
                .frame(width: 29, height: 29)
            Text(type.displayText)
                .font(.system(size: 9))
        }
    }
}

#Preview {
    SocialMediaItemView(type: .facebook)
}
