//
//  RegistrationCoordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 1.02.2022.
//

import UIKit

final class RegistrationCoordinator: Coordinator {

    typealias Controller = RegistrationViewController

    weak var navigator: Navigator?

    private func start(navigate: UIViewController, registrationCompletion: VoidCallback?, loginCompletion: VoidCallback?) {
        let (navigator, view) = createNavigatorWithRootViewController()
        let viewModel = RegistrationViewModel(view: view,
                                              registrationCompletion: registrationCompletion,
                                              loginCompletion: loginCompletion)
        viewModel.coordinator = self
        view.viewModel = viewModel

        defer { self.navigator = navigator }

        navigate.present(navigator, animated: true)
    }

    func start(registrationCompletion: VoidCallback?, loginCompletion: VoidCallback?) {
        if let navigator = UIViewController.topMostViewController {
            start(navigate: navigator,
                  registrationCompletion: registrationCompletion,
                  loginCompletion: loginCompletion)
        }
    }

    func login(loginCompletion: VoidCallback?, registrationCompletion: VoidCallback?) {
        LoginCoordinator().start(loginCompletion: loginCompletion,
                                 registrationCompletion: registrationCompletion)
    }
}

// MARK: - URLNavigatable
extension RegistrationCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return false
    }
    
    static var instance: URLNavigatable {
        return RegistrationCoordinator()
    }
    
    
    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .registration) { _ in
            RegistrationCoordinator().start(registrationCompletion: nil, loginCompletion: nil)
        }
    }
}
