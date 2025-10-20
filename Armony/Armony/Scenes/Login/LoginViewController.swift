//
//  LoginViewController.swift
//  Armony
//
//  Created by Koray Yıldız on 25.01.2022.
//

import UIKit

protocol LoginViewDelegate: AnyObject, NavigationBarCustomizing {
    func configureUI()

    func startLoginButtonActivityIndicatorView()
    func stopLoginButtonActivityIndicatorView()
}

public final class LoginViewController: UIViewController, ViewController {

    public static var storyboardName: UIStoryboard.Name = .login

    @IBOutlet private weak var navigationBarImageView: UIImageView!
    @IBOutlet private weak var gradientView: GradientView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var emailTextField: ValidatableTextField!
    @IBOutlet private weak var passwordTextField: ValidatableTextField!

    @IBOutlet private weak var forgetPasswordButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signupButton: UIButton!

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
        if passwordTextField.isSecureTextEntry {
            return .registrationPasswordHiddenIcon
        }
        else {
            return .registrationPasswordShowIcon
        }
    }

    var viewModel: LoginViewModel!

    private lazy var validationResponders = ValidationResponders(
        required: [
            emailTextField, passwordTextField
        ]
    )

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()

        validationResponders.didValidate = { [weak self] result in
            self?.loginButton.isEnabled = result.isValid
            self?.loginButton.backgroundColor = result.isValid ? .armonyPurple : .armonyPurpleLow
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
    }

    @IBAction private func forgetPasswordButtonTapped() {
        viewModel.forgetPasswordButtonTapped(email: emailTextField.text.emptyIfNil)
    }

    @IBAction private func loginButtonTapped() {
        let credential = LoginCredential(email: emailTextField.text.emptyIfNil,
                                         password: passwordTextField.text.emptyIfNil)
        viewModel.login(with: credential)
    }

    @IBAction private func signupPasswordButtonTapped() {
        viewModel.coordinator.dismiss(animated: true) { [weak self] in
            self?.viewModel.coordinator.registration(registrationCompletion: self?.viewModel.registrationCompletion,
                                                      loginCompletion: self?.viewModel.loginCompletion)
        }
    }

    private func configureEmailAndPasswordTextFields() {
        emailTextField.placeholder = "E-mail"
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.keyboardType = .emailAddress

        emailTextField.rules = ValidationRuleSet(
            rules: [
                ValidationRuleEmailRegex()
            ]
        )

        passwordTextField.placeholder = String("Password", table: .common)

        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true

        passwordTextField.rightView = hideShowPasswordButton
        passwordTextField.rightViewMode = .always

        passwordTextField.rules = ValidationRuleSet(
            rules: [
                Validation.Rule.Length(min: 6, max: 300, error: String("Common.Validation.Password.Error", table: .common))
            ]
        )
    }

    @objc private func hideShowPasswordButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        hideShowPasswordButton.setImage(hideShowPasswordButtonImage, for: .normal)
    }
}

// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func configureUI() {
        view.backgroundColor = .armonyBlack
        navigationBarImageView.setAlpha(.medium)
        gradientView.configure(with: .init(orientation: .vertical, color: .login))
        titleLabel.text = String("SignIn", table: .common)
        titleLabel.textColor = .armonyWhite
        titleLabel.font = .semiboldTitle

        forgetPasswordButton.setTitle(String("ForgetPassword", table: .common),
                                      for: .normal)
        forgetPasswordButton.setTitleColor(.armonyWhite, for: .normal)
        forgetPasswordButton.titleLabel?.font = .lightBody

        loginButton.setTitle(String("SignIn", table: .common),
                             for: .normal)
        loginButton.isEnabled = false
        loginButton.backgroundColor = .armonyPurpleLow
        loginButton.setTitleColor(.armonyWhite, for: .normal)
        loginButton.setTitleColor(.armonyWhiteMedium, for: .disabled)
        loginButton.titleLabel?.font = .semiboldHeading

        signupButton.setTitle(String("SignUp", table: .common),
                              for: .normal)
        signupButton.titleLabel?.font = .lightBody
        signupButton.setTitleColor(.armonyWhite, for: .normal)

        // TODO: Refactor here
//        configureNavigation()
        configureEmailAndPasswordTextFields()

        view.addTapGestureRecognizer { [weak self] _ in
            self?.view.endEditing(true)
        }
    }

    func startLoginButtonActivityIndicatorView() {
        loginButton.startActivityIndicatorView()
    }

    func stopLoginButtonActivityIndicatorView() {
        loginButton.stopActivityIndicatorView()
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate { }
