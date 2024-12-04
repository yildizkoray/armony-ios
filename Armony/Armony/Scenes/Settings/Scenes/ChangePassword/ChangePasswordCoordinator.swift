//
//  ChangePasswordCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 31.07.22.
//

import UIKit

final class ChangePasswordCoordinator: Coordinator {

    typealias Controller = ChangePasswordViewController
    
    weak var navigator: Navigator?
    
    init(navigator: Navigator? = nil) {
        self.navigator = navigator
    }

    func start() {
        let view = createViewController()
        let viewModel = ChangePasswordViewModel(view: view)
        viewModel.coordinator = self
        view.viewModel = viewModel
        navigator?.pushViewController(view, animated: true)
    }
}

// MARK: - URLNavigatable
extension ChangePasswordCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return true
    }
    
    static var instance: URLNavigatable {
        return ChangePasswordCoordinator.init()
    }

    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .changePassword) { result in
            ChangePasswordCoordinator(navigator: result.navigator).start()
        }
    }
}
