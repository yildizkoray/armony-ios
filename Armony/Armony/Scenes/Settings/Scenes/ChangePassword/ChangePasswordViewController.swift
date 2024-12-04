//
//  ChangePasswordViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 31.07.22.
//

import UIKit

protocol ChangePasswordViewDelegate: AnyObject {
    func configureUI()

    func startSaveButtonActivityIndicatorView()
    func stopSaveButtonActivityIndicatorView()
}

final class ChangePasswordViewController: UIViewController, ViewController {

    @IBOutlet private weak var currentPasswordTextField: ValidatableTextField!
    @IBOutlet private weak var newPasswordTextField: ValidatableTextField!
    @IBOutlet private weak var saveButton: UIButton!

    static var storyboardName: UIStoryboard.Name = .settings

    var viewModel: ChangePasswordViewModel!

    private lazy var validationResponders = ValidationResponders(
        required: [currentPasswordTextField, newPasswordTextField]
    )

    private lazy var hideShowPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(hideShowPasswordButtonTapped), for: .touchUpInside)
        button.setImage(hideShowPasswordButtonImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant:  40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(hideShowPasswordButtonTapped), for: .touchUpInside)
        button.setImage(hideShowPasswordButtonImage, for: .normal)
        return button
    }()

    private var hideShowPasswordButtonImage: UIImage {
        if newPasswordTextField.isSecureTextEntry {
            return .registrationPasswordHiddenIcon
        }
        else {
            return .registrationPasswordShowIcon
        }
    }

    @IBAction private func saveButtonTapped() {
        viewModel.saveButtonTapped(currentPassword: currentPasswordTextField.text, newPassword: newPasswordTextField.text)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        view.addTapGestureRecognizer { containerView in
            containerView.endEditing(true)
        }

        validationResponders.didValidate = { [weak self] result in
            self?.saveButton.isEnabled = result.isValid
            self?.saveButton.backgroundColor = result.isValid ? .armonyPurple : .armonyPurpleLow
        }
    }

    private func configureSaveButton() {
        saveButton.setTitle(
            String(localized: "Common.Save", table: "Common+Localizable"), 
            for: .normal
        )
        saveButton.setTitleColor(.armonyWhite, for: .normal)
        saveButton.setTitleColor(.armonyWhiteMedium, for: .disabled)
        saveButton.titleLabel?.font = .semiboldHeading
        saveButton.isEnabled = false
        saveButton.backgroundColor = .armonyPurpleLow
        saveButton.makeAllCornersRounded(radius: .medium)
    }

    private func configurePasswordTextFields() {
        currentPasswordTextField.isSecureTextEntry = true
        currentPasswordTextField.placeholder = "Mevcut Sifre".needLocalization

        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.placeholder = "Yeni Sifre".needLocalization

        newPasswordTextField.rightView = hideShowPasswordButton
        newPasswordTextField.rightViewMode = .always

        newPasswordTextField.rules = ValidationRuleSet(
            rules: [
                Validation.Rule.Length(min: 6, max: 300, error: "Şifreniz minimum 6 karakter olmalı")
            ]
        )
    }

    @objc private func hideShowPasswordButtonTapped() {
        newPasswordTextField.isSecureTextEntry.toggle()
        hideShowPasswordButton.setImage(hideShowPasswordButtonImage, for: .normal)
    }
}

// MARK: - ChangePasswordViewDelegate
extension ChangePasswordViewController: ChangePasswordViewDelegate {
    func configureUI() {
        configurePasswordTextFields()
        configureSaveButton()
        title = "Şifre Değiştir"
    }
    func startSaveButtonActivityIndicatorView() {
        saveButton.startActivityIndicatorView()
    }

    func stopSaveButtonActivityIndicatorView() {
        saveButton.stopActivityIndicatorView()
    }
}
