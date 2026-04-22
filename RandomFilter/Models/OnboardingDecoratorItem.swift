//
//  OnboardingDecoratorItem.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 18/4/26.
//

import Foundation
import SwiftUI

enum OnboardingDecoratorType {
    case image(ImageResource, size: CGFloat)
    case text(String)
}

struct OnboardingDecoratorItem: Identifiable {
    let id: UUID = UUID()
    let type: OnboardingDecoratorType
    let offset: CGPoint
    let rotation: Angle
}
