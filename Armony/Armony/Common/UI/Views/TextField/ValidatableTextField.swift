//
//  ValidatableTextField.swift
//  Armony
//
//  Created by Koray Yildiz on 21.02.23.
//

import SkyFloatingLabelTextField
import UIKit

final class ValidatableTextField: SkyFloatingLabelTextField, ValidationResponder {

    private weak var proxyDelegate: UITextFieldDelegate?

    var validationDelegate: ValidationResponderDelegate?

    public weak override var delegate: UITextFieldDelegate? {
        didSet {
            if let delegate = delegate, delegate !== self {
                proxyDelegate = delegate
                self.delegate = self
            }
        }
    }

    var validationResult: Validation.Result? {
        didSet {
            errorMessage = validationResult?.error
        }
    }

    var rules = ValidationRuleSet<String>()

    var editingRules = ValidationRuleSet<String>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addEditingObservers()
        configureAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addEditingObservers()
        configureAppearance()
    }

    private func configureAppearance() {
        placeholderFont = .lightSubheading
        placeholderColor = .armonyWhiteMedium

        textColor = .armonyWhite
        font = .regularSubheading
        
        lineColor = .armonyBlue
        selectedLineColor = .armonyBlue

        titleColor = .armonyWhiteMedium
        selectedTitleColor = .armonyWhiteMedium

        titleErrorColor = .armonyWhiteMedium
        lineErrorColor = .armonyBlue
        textErrorColor = .armonyWhite
        errorColor = .armonyRed

        errorMessagePlacement = .bottom

        titleFormatter = { $0 }
    }

    override func errorHeight() -> CGFloat {
        if errorMessagePlacement == .bottom {
            return 20
        }
        return super.errorHeight()
    }

    private func addEditingObservers() {
        addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
        addTarget(self, action: #selector(didEditingChange), for: .editingChanged)

        self.delegate = self
    }

    @objc private func didBeginEditing() {
        if text.isNilOrEmpty {
            validationResult = nil
        }
        else {
            validationResult = rules.validate(input: text)
        }
        validationDelegate?.responderDidValidate(self)
    }

    @objc private func didEndEditing() {
        if text.emptyIfNil.isNotEmpty {
            validationResult = rules.validate(input: text)
        }
        else {
            validationResult = nil
        }
        validationDelegate?.responderDidValidate(self)
    }

    @objc private func didEditingChange() {
        if text.isNilOrEmpty {
            validationResult = nil
        }
        else {
            validationResult = rules.validate(input: text)
        }
        validationDelegate?.responderDidValidate(self)
    }

    func validate() {
        didBeginEditing()
    }

    func revalidate() {
        didBeginEditing()
    }
}

// MARK: - UITextFieldDelegate
extension ValidatableTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let textField = textField as? ValidatableTextField else { return true }

        if string.isNotEmpty {
            var text = textField.text.emptyIfNil
            text.replaceSubrange(range.toRange(string: text), with: string)

            if textField.editingRules.validate(input: string).isInvalid {
                return false
            }
        }

        let proxyIsValid = proxyDelegate?.textField?(textField, shouldChangeCharactersIn: range,
                                                     replacementString: string)
        return proxyIsValid.ifNil(true)
    }

    public func textFieldDidChangeSelection(_ textField: UITextField) {
        proxyDelegate?.textFieldDidChangeSelection?(textField)
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return proxyDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        proxyDelegate?.textFieldDidBeginEditing?(textField)
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return proxyDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        proxyDelegate?.textFieldDidEndEditing?(textField)
    }

    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        proxyDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return proxyDelegate?.textFieldShouldClear?(textField) ?? true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return proxyDelegate?.textFieldShouldReturn?(textField) ?? true
    }
}

