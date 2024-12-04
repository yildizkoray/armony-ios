//
//  VisitedAccountCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 11.12.22.
//

import UIKit

final class VisitedAccountCoordinator: Coordinator {
    typealias Controller = VisitedAccountViewController

    weak var navigator: Navigator?

    init(navigator: Navigator? = nil) {
        self.navigator = navigator
    }

    func start(with userID: String) {
        let view = createViewController()

        let viewModel = VisitedAccountViewModel(view: view, userID: userID)
        viewModel.coordinator = self

        view.viewModel = viewModel

        navigator?.pushViewController(view, animated: true)
    }

    func avatar(with imageSource: ImageSource) {
        AvatarCoordinator().start(onto: navigator, imageSource: imageSource)
    }
}

// MARK: - URLNavigatable
extension VisitedAccountCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return false
    }

    static var instance: URLNavigatable {
        return VisitedAccountCoordinator()
    }

    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .visitedAccount) { result in
            if let userID: String = result.value(forKey: "UserID") {
                
                VisitedAccountCoordinator(navigator: result.navigator).start(with: userID)
            }
        }
    }
}
