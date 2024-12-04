//
//  NSRange+Extensions.swift
//  Armony
//
//  Created by Koray Yildiz on 23.02.23.
//

import Foundation

public extension NSRange {

    func toRange(string: String) -> Range<String.Index> {
        let startIndex = string.index(string.startIndex, offsetBy: location)
        let endIndex = string.index(startIndex, offsetBy: length)

        return startIndex..<endIndex
    }
}
