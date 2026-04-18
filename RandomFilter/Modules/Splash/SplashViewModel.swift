//
//  SplashViewModel.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import Foundation
import Combine
import SwiftUI

class SplashViewModel: BaseViewModel {
    
    
    @Published var progress: CGFloat = 0

    let event = PassthroughSubject<SplashEvent, Never>()

    
    var duration: CGFloat = 3

    func start() {
           withAnimation(.linear(duration: duration)) {
               progress = 1
           }
           
           DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
               self.event.send(.didFinish)
           }
       }
    
}
