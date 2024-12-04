//
//  AccountCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 18.04.22.
//

import UIKit

final class AccountCoordinator: Coordinator {
    typealias Controller = AccountViewController

    weak var navigator: Navigator?

    func start() -> Navigator {
        let view = createViewController()

        let viewModel = AccountViewModel(view: view)
        viewModel.coordinator = self
        
        view.viewModel = viewModel

        let navigator = Navigator(rootViewController: view)

        defer {
            self.navigator = navigator
        }

        navigator.tabBarItem = UITabBarItem(
            title: String(localized: "Profile", table: "Account+Localizable"),
            image: .tabAccountDefaultIcon,
            selectedImage: .tabAccountSelectedIcon
        )

        navigator.tabBarItem.imageInsets = .init(top: 2, left: .zero, bottom: .zero, right: .zero)

        return navigator
    }

    func settings() {
        SettingsCoordinator(navigator: navigator).start()
    }

    func profile(presentation: ProfilePresentation, delegate: ProfileViewModelDelegate?) {
        ProfileCoordinator(navigator: navigator).start(with: presentation, delegate: delegate)
    }

    func avatar(imageSource: ImageSource) {
        AvatarCoordinator().start(onto: navigator, imageSource: imageSource)
    }
}

// MARK: - URLNavigatable
extension AccountCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return true
    }

    static var instance: URLNavigatable {
        return AccountCoordinator()
    }

    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .account) { result in
            let view = selectTab(tab: .account, shouldPopToRoot: true)

            if let selectedTabIndex: String = result.value(forKey: "SelectedTabIndex") {
                if let view = view as? AccountCoordinator.Controller {
                    view.viewModel.currentSelectedSegmentIndex = Int(selectedTabIndex).ifNil(.zero)
                    if view.isViewLoaded {
                        view.selectSegment(at: Int(selectedTabIndex).ifNil(.zero))
                    }
                }
            }
        }
    }
}
