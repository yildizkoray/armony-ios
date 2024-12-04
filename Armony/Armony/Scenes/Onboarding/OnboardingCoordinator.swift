//
//  OnboardingCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 13.06.22.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    typealias Controller = OnboardingViewController

    private weak var navigator: UIViewController?

    init(navigator: UIViewController) {
        self.navigator = navigator
    }

    func start() {
        let view = createViewController()
        view.modalPresentationStyle = .fullScreen
        let viewModel = OnboardingViewModel(view: view)
        viewModel.coordinator = self

        view.viewModel = viewModel

        navigator?.present(view, animated: true)
    }

    func dismiss(animated: Bool, completion: VoidCallback?) {
        UIApplication.tabBarController?.dismiss(animated: true, completion: completion)
    }

    func registration(didRegister : @escaping VoidCallback) {
        RegistrationCoordinator().start {
            didRegister()
        } loginCompletion: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
