//
//  SettingsCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 27.05.22.
//

import UIKit
import SwiftUI

final class SettingsCoordinator: Coordinator {
    typealias Controller = SettingsViewController

    weak var navigator: Navigator?

    init(navigator: Navigator?) {
        self.navigator = navigator
    }

    func start() {
        let view = createViewController()
        let viewModel = SettingsViewModel(view: view)
        viewModel.coordinator = self

        view.viewModel = viewModel
        navigator?.pushViewController(view, animated: true)
    }
}

// MARK: - URLNavigatable
extension SettingsCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return true
    }

    static var instance: URLNavigatable {
        return SettingsCoordinator(navigator: nil)
    }

    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .settings) { result in
            SettingsCoordinator(navigator: result.navigator!).start()
        }
    }
}
