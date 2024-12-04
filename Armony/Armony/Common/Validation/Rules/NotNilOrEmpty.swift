//
//  NotNilOrEmpty.swift
//  Armony
//
//  Created by Koray Yildiz on 24.02.23.
//

import Foundation

class ValidationRuleNotNilOrEmpty: Validation.Rule.Condition<String> {

    init(error: String) {
        super.init(error: error, condition: { $0.isNotNilOrEmpty })
    }
}
