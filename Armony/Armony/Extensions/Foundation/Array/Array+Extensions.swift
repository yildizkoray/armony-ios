//
//  Array+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 28.08.2021.
//

import Foundation

public extension Array {

    static var empty: Array {
        return []
    }

    func element(at index: Index) -> Element? {
        guard index >= .zero && index < count else { return nil }
        return self[index]
    }
}

// MARK: - Array + Equatable
public extension Array where Element: Equatable {

    mutating func remove(element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        }
    }
}
