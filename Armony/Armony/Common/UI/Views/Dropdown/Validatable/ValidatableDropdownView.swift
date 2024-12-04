//
//  ValidatableDropdownView.swift
//  Armony
//
//  Created by Koray Yildiz on 24.02.23.
//

import Foundation

// MARK: - ValidatableDropdownView
final class ValidatableDropdownView: DropdownView, ValidationResponder {

    var validationDelegate: ValidationResponderDelegate?
    var validationResult: Validation.Result?{
        didSet {
            validationDelegate?.responderDidValidate(self)
        }
    }

    private let rules: ValidationRuleSet<String> = ValidationRuleSet(
        rules: [Validation.Rule.NotNilOrEmpty(error: .empty)]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        validationResult = textField.text.isNilOrEmpty ? .invalid(.empty) : .valid
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        validationResult = textField.text.isNilOrEmpty ? .invalid(.empty) : .valid
    }

    override func updateText(_ text: String?) {
        super.updateText(text)
        validationResult = rules.validate(input: textField.text)
    }

    func revalidate() {
        validationResult = rules.validate(input: textField.text)
    }
}
