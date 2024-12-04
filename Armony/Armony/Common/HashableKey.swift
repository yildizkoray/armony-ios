//
//  HashableKey.swift
//  Armony
//
//  Created by Koray Yildiz on 17.02.23.
//

import Foundation

public struct HashableKey: ExpressibleByStringLiteral, Hashable {

    private(set) var value: String

    public init(stringLiteral value: StringLiteralType) {
        self.value = value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

