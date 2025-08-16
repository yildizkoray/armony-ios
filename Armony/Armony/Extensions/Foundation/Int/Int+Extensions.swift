//
//  Int+Extensions.swift
//  Armony
//
//  Created by Koray Yildiz on 29.12.22.
//

import Foundation

extension Int {

    var isZero: Bool {
        return self == .zero
    }

    var string: String {
        return String(self)
    }

    static var invalid: Int {
        return NSNotFound
    }

    func backendLocalizedText(table: Localization.Table.Backend) -> String {
        let key = String(table.rawValue.titled.dropLast() + "_\(self)")
        return String(localized: String.LocalizationValue(key), table: table.description + "+Localizable")
    }
}


extension Double   {
    var ns: NSNumber {
        NSNumber(value: self)
    }
}
