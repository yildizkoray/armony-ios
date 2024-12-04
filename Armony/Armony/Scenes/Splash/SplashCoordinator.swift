//
//  SplashCoordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 11.02.2022.
//

import UIKit

final class SplashCoordinator: Coordinator {
    typealias Controller = SplashViewController

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let view = createViewController()
        let viewModel = SplashViewModel()
        view.viewModel = viewModel
        viewModel.coordinator = self

        window.setRootViewController(view, animated: false)
    }

    func armony() {
        AppCoordinator(window: window).startAsArmony()
    }
}
