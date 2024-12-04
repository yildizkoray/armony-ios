//
//  Length.swift
//  Armony
//
//  Created by Koray Yildiz on 23.02.23.
//

import Foundation

final class ValidationRuleLength: Validation.Rule.Condition<String> {

    public init(min: Int = 0, max: Int = .max, error: String) {
        super.init(error: error, condition: { input in
            guard let input = input else { return false }
            return min...max ~= input.count
        })
    }
}
