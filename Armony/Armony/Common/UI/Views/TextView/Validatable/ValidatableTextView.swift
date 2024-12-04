//
//  ValidatableTextView.swift
//  Armony
//
//  Created by Koray Yildiz on 28.02.23.
//

import UIKit

final class ValidatableTextView: TextView, ValidationResponder {

    var validationResult: Validation.Result? {
        didSet {
            validationDelegate?.responderDidValidate(self)
        }
    }
    var validationDelegate: ValidationResponderDelegate?

    var rules: ValidationRuleSet<String> = ValidationRuleSet()

    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)

        validationResult = validate(for: textView.text)
    }

    override func textViewDidBeginEditing(_ textView: UITextView) {
        super.textViewDidBeginEditing(textView)

        validationResult = validate(for: textView.text)
    }

    private func validate(for text: String?) -> Validation.Result? {
        guard let text = text,
              text.isNotEmpty else {
            return nil
        }

        return rules.validate(input: text)
    }

    func revalidate() {
        validationResult = validate(for: textView.text)
    }
}
