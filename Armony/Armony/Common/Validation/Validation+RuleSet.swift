//
//  Validation+RuleSet.swift
//  Armony
//
//  Created by Koray Yildiz on 17.07.22.
//

import Foundation

extension Validation {
    typealias RuleSet = ValidationRuleSet
}

struct ValidationRuleSet<Input> {

    fileprivate struct AnyRule<T>: Validation.Rule {
        let error: String
        let validation: (T?) -> Bool

        public init<R: Validation.Rule>(base: R) where R.Input == T {
            error = base.error
            validation = base.validate
        }

        func validate(input: T?) -> Bool {
            return validation(input)
        }
    }

    private var rules: [AnyRule<Input>]

    public init<R: Validation.Rule>(rules: [R]) where R.Input == Input {
        self.rules = rules.map(AnyRule.init)
    }

    public init() {
        self.rules = .empty
    }

    public var isEmpty: Bool { return rules.isEmpty }

    public mutating func add<R: Validation.Rule>(rule: R) where R.Input == Input {
        rules.append(AnyRule(base: rule))
    }

    public func validate(input: Input?) -> Validation.Result {
        return Validator.validate(input: input, rules: rules)
    }
}
