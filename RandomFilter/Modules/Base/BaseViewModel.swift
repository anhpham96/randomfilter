//
//  BaseViewModel.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 17/4/26.
//

import Foundation
import Combine

class BaseViewModel: NSObject, ObservableObject {

    @Published var isLoading = false
    @Published var customError: String?
    @Published var error: Error?

    var bag = Set<AnyCancellable>()

    deinit {
        bag.removeAll()


        print(String(describing: Self.self), "is deallocated")

    }

}
