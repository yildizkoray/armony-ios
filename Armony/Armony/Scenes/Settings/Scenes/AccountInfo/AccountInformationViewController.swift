//
//  AccountInformationViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 21.06.22.
//

import UIKit

protocol AccountInformationViewDelegate: AnyObject, ActivityIndicatorShowing {
    var name: String? { get }

    func configureUI()
    func configureNameTextField(name: String?)
    func configureEmailTextField(email: String?)

    func setContainerViewVisibility(isHidden: Bool)

    func startDeleteAccountButtonActivityIndicatorView()
    func stopDeleteAccountButtonActivityIndicatorView()

    func startSaveButtonActivityIndicatorView()
    func stopSaveButtonActivityIndicatorView()
}

final class AccountInformationViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .settings

    var viewModel: AccountInformationViewModel!

    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var nameTextField: ValidatableTextField!
    @IBOutlet private weak var emailTextField: ValidatableTextField!
    @IBOutlet private weak var deleteAccountButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!

    private lazy var validationResponders = ValidationResponders(required: [nameTextField])

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        view.addTapGestureRecognizer(cancelsTouches: false) { [weak self] _ in
            self?.view.endEditing(true)
        }
    }

    @IBAction private func saveButtonTapped() {
        viewModel.saveButtonTapped(name: nameTextField.text.emptyIfNil)
    }

    @IBAction private func deleteAccountButtonTapped() {
        viewModel.deleteAccountButtonTapped()
    }

    //    MARK: - Configuration TextFields
    private func configureNameTextField() {
        nameTextField.placeholder = "İsim Soyisim" // TODO: - Localizable

        nameTextField.autocapitalizationType = .words
        nameTextField.autocorrectionType = .no

        nameTextField.rules = ValidationRuleSet(
            rules: [
                Validation.Rule.Length(min: 3, max: 40, error: "En az 3 en fazla 40 karakter giriniz")
            ]
        )

        validationResponders.didValidate = { [weak self] result in
            self?.saveButton.isEnabled = result.isValid
            self?.saveButton.backgroundColor = result.isValid ? .armonyPurple : .armonyPurpleLow
        }
    }

    private func configureEmailTextField() {
        emailTextField.textColor = .armonyWhiteMedium

        emailTextField.placeholder = "E-posta" // TODO: - Localizable
        emailTextField.isUserInteractionEnabled = false
    }

    private func configureSaveButton() {
        saveButton.setTitle(String(localized: "Common.Save", table: "Common+Localizable"), for: .normal)
        saveButton.setTitleColor(.armonyWhite, for: .normal)
        saveButton.setTitleColor(.armonyWhiteMedium, for: .disabled)
        saveButton.titleLabel?.font = .semiboldHeading
        saveButton.isEnabled = true
        saveButton.backgroundColor = .armonyPurple
        saveButton.makeAllCornersRounded(radius: .medium)
    }

    private func configureDeleteAccountButton() {
        deleteAccountButton.setTitle("Hesabımı Sil", for: .normal)
        deleteAccountButton.setTitleColor(.armonyWhite, for: .normal)
        deleteAccountButton.titleLabel?.font = .lightBody
        deleteAccountButton.isEnabled = true
        deleteAccountButton.backgroundColor = .clear
        deleteAccountButton.makeAllCornersRounded(radius: .medium)
    }
}

// MARK: - AccountInformationViewDelegate
extension AccountInformationViewController: AccountInformationViewDelegate {
    var name: String? {
        nameTextField.text
    }

    func configureUI() {
        view.backgroundColor = .armonyBlack
        title = "Hesap Bilgileri"

        configureNameTextField()
        configureEmailTextField()
        configureSaveButton()
        configureDeleteAccountButton()
    }

    func configureNameTextField(name: String?) {
        nameTextField.text = name
    }

    func configureEmailTextField(email: String?) {
        emailTextField.text = email
    }

    func setContainerViewVisibility(isHidden: Bool) {
        containerStackView.setHidden(isHidden)
    }

    func startSaveButtonActivityIndicatorView() {
        saveButton.startActivityIndicatorView()
    }

    func stopSaveButtonActivityIndicatorView() {
        saveButton.stopActivityIndicatorView()
    }

    func startDeleteAccountButtonActivityIndicatorView() {
        deleteAccountButton.startActivityIndicatorView()
    }

    func stopDeleteAccountButtonActivityIndicatorView() {
        deleteAccountButton.stopActivityIndicatorView()
    }
}
