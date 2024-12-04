//
//  AccountInformationCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 21.06.22.
//

import UIKit

final class AccountInformationCoordinator: Coordinator, SelectionBottomPopUpOpening {
    typealias Controller = AccountInformationViewController

    weak var navigator: Navigator?

    init(navigator: Navigator?) {
        self.navigator = navigator
    }

    func start() {
        let view = createViewController()
        let viewModel = AccountInformationViewModel(view: view)
        viewModel.coordinator = self
        view.viewModel = viewModel

        navigator?.pushViewController(view, animated: true)
    }

    func startFromSktratch() {
        AppCoordinator(window: UIApplication.window!).start()
    }
}

// MARK: - URLNavigatable
extension AccountInformationCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return true
    }

    static var instance: URLNavigatable {
        AccountInformationCoordinator(navigator: nil)
    }
    

    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .accountInformation) { result in
            if let navigation = result.navigator {
                AccountInformationCoordinator(navigator: navigation).start()
            }
        }
    }
}
