//
//  Optional+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

extension Optional {

    var isNil: Bool {
        self == nil
    }

    var isNotNil: Bool {
        self != nil
    }
}

// MARK: - Optional + String
extension Optional where Wrapped == String {
    var emptyIfNil: Wrapped {
        return ifNil(.empty)
    }

    var isNilOrEmpty: Bool {
        return ifNil(.empty).isEmpty
    }

    var isNotNilOrEmpty: Bool {
        return !isNilOrEmpty
    }
}

// MARK: - Optional + Any
public extension Optional where Wrapped: Any {

    func ifNil(_ value: @autoclosure () -> Wrapped) -> Wrapped {

        switch self {
        case .none:
            return value()

        case .some(let value):
            return value
        }
    }
}
