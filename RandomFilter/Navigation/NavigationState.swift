//
//  NavigationState.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//

import Combine
import SwiftUI

@MainActor
class NavigationState: ObservableObject {
    @Published var routes = NavigationPath()
    
    func popToRoot() {
        routes.removeLast(routes.count)
    }
}
