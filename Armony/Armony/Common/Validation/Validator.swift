//
//  Validator.swift
//  Armony
//
//  Created by Koray Yildiz on 16.07.22.
//

import Foundation

final class Validator {

    class func validate<R: Validation.Rule>(input: R.Input?, rule: R) -> Validation.Result {
        return rule.validate(input: input) ? .valid : .invalid(rule.error)
    }


    public class func validate<R: Validation.Rule>(input: R.Input?, rules: [R]) -> Validation.Result {
        for rule in rules {
            let result = validate(input: input, rule: rule)
            if result.isInvalid { return result }
        }
        return .valid
    }
}
