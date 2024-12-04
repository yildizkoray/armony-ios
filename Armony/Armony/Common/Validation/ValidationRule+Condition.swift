//
//  Condition.swift
//  Armony
//
//  Created by Koray Yildiz on 24.02.23.
//

import Foundation

class ValidationRuleCondition<Input>: Validation.Rule {

    public let error: String
    public let condition: (Input?) -> Bool

    public init(error: String, condition: @escaping ((Input?) -> Bool)) {
        self.condition = condition
        self.error = error
    }

    public func validate(input: Input?) -> Bool {
        return condition(input)
    }
}
