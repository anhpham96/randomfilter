//
//  Decimal+Extensions.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 18/4/26.
//

import Foundation

extension Double {

    func currencyFormat(code: String = Locale.current.currency?.identifier ?? "USD",
                        locale: Locale = .current) -> String {

        let formatter = NumberFormatter.sharedCurrency
        formatter.currencyCode = code
        formatter.locale = locale

        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
