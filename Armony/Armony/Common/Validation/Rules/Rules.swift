//
//  Rules.swift
//  Armony
//
//  Created by Koray Yildiz on 23.02.23.
//

import Foundation

extension Validation.Rule {
    typealias Condition = ValidationRuleCondition
    
    typealias Equal = ValidationRuleEqual
    typealias Length = ValidationRuleLength
    typealias NotNilOrEmpty = ValidationRuleNotNilOrEmpty
    typealias Regex = ValidationRuleRegex
}
