//
//  Equal.swift
//  Armony
//
//  Created by Koray Yildiz on 23.02.23.
//

import Foundation

final class ValidationRuleEqual<Input: Equatable>: Validation.Rule.Condition<Input> {

    public init(equals: @escaping @autoclosure () -> Input, error: String) {
        super.init(error: error, condition: { $0 == equals() })
    }
}
