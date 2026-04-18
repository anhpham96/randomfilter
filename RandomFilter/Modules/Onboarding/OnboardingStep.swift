//
//  OnboardingStep.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import Foundation
import SwiftUI

enum OnboardingStep: String, Identifiable, CaseIterable {
    var id: String { rawValue }

    case one, two, three

    var index: Int {
        Self.allCases.firstIndex(of: self)! + 1
    }

    var introduceText: String {
        switch self {
        case .one:
            return "Clean, minimal, and chic style? See how you'd look!"
        case .two:
            return "Accurate Predictions Filter!\nSee your future life!"
        case .three:
            return "Share & Have Fun! Share them on TikTok, Instagram, and Snapchat"
        }
    }

    var screenShotImage: ImageResource {
        ImageResource(name: "onboarding.screenshot.\(rawValue)", bundle: .main)
    }

    var rotationBackground: CGFloat {
        switch self {
        case .one, .two:
            return 0
        case .three:
            return -180
        }
    }

    var next: OnboardingStep? {
        let all = Self.allCases
        guard let index = all.firstIndex(of: self),
              index + 1 < all.count else {
            return nil
        }
        return all[index + 1]
    }
    
    var decoratorItems: [OnboardingDecoratorItem] {
        switch self {
        case .one:
            return [OnboardingDecoratorItem(type: .text("Your Outfit"), offset: .init(x: -100, y: 0), rotation: .degrees(-15.18)),
                    OnboardingDecoratorItem(type: .text("Stuck For\nIdeas?"), offset: .init(x: 100, y: -100), rotation: .degrees(13.5))]
        case .two:
            return [OnboardingDecoratorItem(type: .text("Make It\nUnique"), offset: .init(x: -100, y: -100), rotation: .degrees(-18.59)),
                    OnboardingDecoratorItem(type: .text("Luxury Life"), offset: .init(x: 100, y: 40), rotation: .degrees(11.13))]
        case .three:
            return [OnboardingDecoratorItem(type: .text("Capture &\nShare"), offset: .init(x: 90, y: -110), rotation: .degrees(11.03)),
                    OnboardingDecoratorItem(type: .text("Friends"), offset: .init(x: -130, y: 50), rotation: .degrees(-14.74)),
                    OnboardingDecoratorItem(type: .image(.logoFacebook, size: 70), offset: .init(x: -130, y: -50), rotation: .zero),
                    OnboardingDecoratorItem(type: .image(.logoInstagram, size: 90), offset: .init(x: 120, y: -30), rotation: .zero),
                    OnboardingDecoratorItem(type: .image(.logoMessenger, size: 60), offset: .init(x: -130, y: 165), rotation: .zero),
                    OnboardingDecoratorItem(type: .image(.logoTiktok, size: 70), offset: .init(x: 120, y: 90), rotation: .zero)]
        }
    }


}
