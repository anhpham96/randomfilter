//
//  Font+Extensions.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import SwiftUI

extension Font {
    
    static func quickSand(_ size: CGFloat) -> Font {
        .custom("Quicksand-Regular", size: size)
    }
    
    static func quickSandMedium(_ size: CGFloat) -> Font {
        .custom("Quicksand-Medium", size: size)
    }
    
    static func quickSandSemiBold(_ size: CGFloat) -> Font {
        .custom("Quicksand-SemiBold", size: size)
    }
    
    static func quickSandBold(_ size: CGFloat) -> Font {
        .custom("Quicksand-Bold", size: size)
    }
    
    static func racingSansOne(_ size: CGFloat) -> Font {
        .custom("RacingSansOne-Regular", size: size)
    }
}
