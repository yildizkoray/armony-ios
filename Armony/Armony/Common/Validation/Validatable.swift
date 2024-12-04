//
//  Validatable.swift
//  Armony
//
//  Created by Koray Yildiz on 16.07.22.
//

import Foundation

protocol Validatable {

    func validate<R: Validation.Rule>(rule: R) -> Validation.Result where R.Input == Self
}

extension Validatable {

    func validate<R: Validation.Rule>(rule: R) -> Validation.Result where R.Input == Self {
        return Validator.validate(input: self, rule: rule)
    }
}

extension Int: Validatable {}
extension Double: Validatable {}
extension Float: Validatable {}

extension String: Validatable {}
extension Array: Validatable {}
