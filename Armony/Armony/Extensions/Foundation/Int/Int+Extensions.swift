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
}


extension Double   {
    var ns: NSNumber {
        NSNumber(value: self)
    }
}
