//
//  Validation+Responder.swift
//  Armony
//
//  Created by Koray Yildiz on 17.07.22.
//

import Foundation

extension Validation {
    typealias Responder = ValidationResponder
}

protocol ValidationResponder: AnyObject {

    var validationResult: Validation.Result? { get }
    var validationDelegate: ValidationResponderDelegate? { get set }

    func revalidate()
}

extension ValidationResponder {

    var isValid: Bool {
        return validationResult?.isValid == true
    }
}

// MARK: - ValidationResponderDelegate

protocol ValidationResponderDelegate: AnyObject {
    func responderDidValidate(_ responder: Validation.Responder)
}

// MARK: - ValidationResponders
final class ValidationResponders {

    public var result: Validation.Result? {
        return isValid ? .valid : .invalid(.empty)
    }

    public var didValidate: Callback<ValidationResponders>?

    public var isValid: Bool {
        guard required.allSatisfy({ $0.isValid }) else { return false }
        return optional.compactMap { $0.validationResult }.allSatisfy { $0.isValid }
    }

    private let required: [Validation.Responder]
    private let optional: [Validation.Responder]

    public init(required: [Validation.Responder], optional: [Validation.Responder] = .empty) {
        self.required = required
        self.optional = optional

        (required + optional).forEach { $0.validationDelegate = self }
    }

    func revalidate() {
        (required + optional).forEach { $0.validationDelegate = self }
        (required + optional).forEach { $0.revalidate() }
    }
}

// MARK: - ValidationResponderDelegate

extension ValidationResponders: ValidationResponderDelegate {

    public func responderDidValidate(_ responder: Validation.Responder) {
        didValidate?(self)
    }
}
