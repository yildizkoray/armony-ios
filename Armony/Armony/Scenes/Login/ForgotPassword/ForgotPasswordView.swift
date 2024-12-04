//
//  ForgotPasswordView.swift
//  Armony
//
//  Created by Koray Yildiz on 15.04.22.
//

import UIKit
import SwiftMessages

public final class ForgotPasswordView: MessageView, NibLoadable {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var emailTextField: ValidatableTextField!
    @IBOutlet private weak var actionButton: UIButton!

    var actionButtonTapped: Callback<String>?

    private var passwordResetEmailDidSend: NotificationToken?
    private var passwordResetEmailDidFail: NotificationToken?

    private lazy var validationResponders = ValidationResponders(required: [emailTextField])

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        prepareUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromNib()
        prepareUI()
    }

    @IBAction private func actionButtonDidTap() {
        actionButton.startActivityIndicatorView()
        actionButtonTapped?(emailTextField.text.emptyIfNil)
    }

    fileprivate func configureActionButton() {
        actionButton.isEnabled = false
        actionButton.backgroundColor = .armonyPurpleLow
        actionButton.setTitle("Tamam".needLocalization, for: .normal)
        actionButton.setTitleColor(.armonyWhite, for: .normal)
        actionButton.setTitleColor(.armonyWhiteMedium, for: .disabled)
        actionButton.titleLabel?.font = .semiboldHeading
        actionButton.makeAllCornersRounded(radius: .medium)

        emailTextField.rules = ValidationRuleSet(
            rules: [
                ValidationRuleEmailRegex()
            ]
        )
    }

    private func prepareUI() {
        backgroundColor = .armonyDarkBlue

        configureEmailTextField()
        configureActionButton()

        title.font = .semiboldTitle
        subtitleLabel.font = .lightBody

        validationResponders.didValidate = { [weak self] result in
            self?.actionButton.isEnabled = result.isValid
            self?.actionButton.backgroundColor = result.isValid ? .armonyPurple : .armonyPurpleLow
        }

        containerView.addTapGestureRecognizer(cancelsTouches: true) { [weak self] _ in
            self?.endEditing(true)
        }

        passwordResetEmailDidSend = NotificationCenter.default.observe(name: .passwordResetEmailDidSend) { [weak self] _ in
            SwiftMessages.hide()
            NotificationCenter.default.removeObserver(self?.passwordResetEmailDidSend as Any)
        }

        passwordResetEmailDidFail = NotificationCenter.default.observe(name: .passwordResetEmailDidFail) { [weak self] _ in
            self?.actionButton.stopActivityIndicatorView()
            NotificationCenter.default.removeObserver(self?.passwordResetEmailDidFail as Any)
        }
    }

    private func configureEmailTextField() {
        emailTextField.placeholder = "E-posta".needLocalization

        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress
    }

    public func configure(with email: String) {
        emailTextField.text = email
        emailTextField.validate()
    }
}
