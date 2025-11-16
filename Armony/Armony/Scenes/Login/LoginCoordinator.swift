//
//  LoginCoordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 25.01.2022.
//

import UIKit
import SwiftMessages

public class LoginCoordinator: Coordinator {

    public typealias Controller = LoginViewController

    weak public var navigator: Navigator?

    public init(navigator: Navigator? = nil) {
        self.navigator = navigator
    }

    private func start(navigator: UIViewController, loginCompletion: VoidCallback?, registrationCompletion: VoidCallback?) {
        let (loginNavigator, view) = createNavigatorWithRootViewController()
        let viewModel = LoginViewModel(view: view, loginCompletion: loginCompletion, registrationCompletion: registrationCompletion)
        viewModel.coordinator = self

        view.viewModel = viewModel
        
        defer { self.navigator = loginNavigator }
        navigator.present(loginNavigator, animated: true)
    }

    func start(loginCompletion: VoidCallback?, registrationCompletion: VoidCallback?) {
        if let navigator = UIViewController.topMostViewController {
            start(navigator: navigator, loginCompletion: loginCompletion, registrationCompletion: registrationCompletion)
        }
    }

    func registration(registrationCompletion: VoidCallback?, loginCompletion: VoidCallback?) {
        RegistrationCoordinator().start(registrationCompletion: registrationCompletion,
                                        loginCompletion: loginCompletion)
    }

    func showForgotPasswordView(email: String, actionButtonTapped: Callback<String>?) {
        let view = ForgotPasswordView()
        view.configureDropShadow()
        view.actionButtonTapped = { email in
            actionButtonTapped?(email)
        }
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .bottom
        config.keyboardTrackingView = KeyboardTrackingView()
        config.dimMode = .color(color: .armonyBlackHigh, interactive: true)
        view.configure(with: email)
        SwiftMessages.show(config: config, view: view)
    }
}
