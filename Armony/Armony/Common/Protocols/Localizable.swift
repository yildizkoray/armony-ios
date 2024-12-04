//
//  Localizable.swift
//  Armony
//
//  Created by Koray Yıldız on 12.10.22.
//

import Foundation

protocol Localizable {
    var rawValue: String { get }
    var localized: String { get }
    var fileName: String { get }

    func localized(_ arg: [CVarArg]) -> String
}

extension Localizable {
    var localized: String {
        let value = NSLocalizedString(rawValue, tableName: fileName, bundle: .main, comment: .empty)
        return value.isEmpty ? rawValue : value
    }

    func localized(_ arg: [CVarArg]) -> String {
        return String(format: localized, arguments: arg)
    }
}
