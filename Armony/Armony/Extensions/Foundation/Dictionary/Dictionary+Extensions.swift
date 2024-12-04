//
//  Dictionary+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

public extension Dictionary {

    static var empty: [String: String] {
        return [:]
    }

    mutating func update(_ dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
}
