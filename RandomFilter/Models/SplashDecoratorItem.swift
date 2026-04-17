//
//  SplashItem.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 16/4/26.
//
import SwiftUI

struct SplashDecoratorItem: Identifiable {
    let id = UUID()
    let image: ImageResource
    let size: CGSize
    let offset: CGSize
    let rotation: Double
    let dropShadowOffset: CGPoint
}


extension SplashDecoratorItem {
    static let items: [SplashDecoratorItem] = [
        .init(
            image: .splashItem1,
            size: CGSize(width: 86, height: 131),
            offset: CGSize(width: -0.22, height: -0.18),
            rotation: 17.07,
            dropShadowOffset: .init(x: 4, y: 4)
        ),
        .init(
            image: .splashItem2,
            size: CGSize(width: 70, height: 70),
            offset: CGSize(width: 0.24, height: -0.02),
            rotation: 13.21,
            dropShadowOffset: .init(x: -4, y: 4)
        ),
        .init(
            image: .splashItem3,
            size: CGSize(width: 98.74, height: 148.34),
            offset: CGSize(width: -0.18, height: 0.20),
            rotation: 22.01,
            dropShadowOffset: .init(x: -2, y: 6)
        ),
        .init(
            image: .splashItem4,
            size: CGSize(width: 103.6, height: 155.4),
            offset: CGSize(width: 0.18, height: 0.22),
            rotation: -10.71,
            dropShadowOffset: .init(x: 4, y: 4)
        )
    ]
}
