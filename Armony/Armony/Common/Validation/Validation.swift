//
//  Validation.swift
//  Armony
//
//  Created by Koray Yildiz on 16.07.22.
//

import Foundation

struct Validation {
    typealias Rule = ValidationRule
}

// MARK: Validation + ValidationRule
protocol ValidationRule {
    associatedtype Input

    var error: String { get }
    func validate(input: Input?) -> Bool
}

// MARK: Validation + Result
extension Validation {

    enum Result: Equatable {
        case invalid(String)
        case valid

        var isValid: Bool {
            return self == .valid
        }

        var isInvalid: Bool {
            return isValid == false
        }

        var error: String {
            switch self {
            case .invalid(let error):
                return error
            case .valid:
                return .empty
            }
        }

        public static func ==(lhs: Result, rhs: Result) -> Bool {
            switch (lhs, rhs) {
            case (.valid, .valid):
                return true
            case (.invalid(let lhsError), .invalid(let rhsError)):
                return lhsError == rhsError
            default:
                return false
            }
        }
    }
}
