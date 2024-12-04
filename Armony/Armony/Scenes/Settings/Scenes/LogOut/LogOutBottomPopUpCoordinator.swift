//
//  LogOutBottomPopUpCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 11.07.22.
//

import Foundation

final class LogOutBottomPopUpCoordinator: Coordinator {
    typealias Controller = LogOutBottomPopUpViewController

    weak var navigator: Navigator?

    init(navigator: Navigator? = nil) {
        self.navigator = navigator
    }

    func start() {
        let view = createViewController()
        let viewModel = LogOutBottomPopUpViewModel(view: view)
        viewModel.coordinator = self
        view.viewModel = viewModel

        navigator?.present(view, animated: true)
    }
}

// MARK: - URLNavigatable
extension LogOutBottomPopUpCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        true
    }
    
    static var instance: URLNavigatable {
        return LogOutBottomPopUpCoordinator.init()
    }
    
    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .logOut) { result in
            if let navigation = result.navigator {
                LogOutBottomPopUpCoordinator(navigator: navigation).start()
            }
        }
    }
}
