//
//  Pattern.swift
//  Armony
//
//  Created by Koray Yildiz on 24.02.23.
//

import Foundation

class ValidationRuleRegex<Input>: Validation.Rule.Condition<Input> {

    init(pattern: String, error: String) {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        super.init(error: error, condition: { predicate.evaluate(with: $0) })
    }
}

// MARK: - EMAIL
final class ValidationRuleEmailRegex: Validation.Rule.Regex<String> {

    public init(error: String = String(localized: "Common.Validation.Error.Email", table: "Common+Localizable")) {
        let pattern = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$"
        super.init(pattern: pattern, error: error)
    }
}
