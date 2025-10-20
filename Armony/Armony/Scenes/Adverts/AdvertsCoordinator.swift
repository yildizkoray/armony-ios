//
//  AdvertsCoordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 22.08.2021.
//

import UIKit

private struct Constant {
    static let defaultTabBarImage = "tab-home-default-icon".image
    static let selectedTabBarImage = "tab-home-selected-icon".image
}

final class AdvertsCoordinator: Coordinator {

    typealias Controller = AdvertsViewController

    weak var navigator: Navigator?

    func start() -> Navigator {
        let view = createViewController()

        let viewModel = AdvertsViewModel(view: view)
        viewModel.coordinator = self

        view.viewModel = viewModel

        let navigator = Navigator(rootViewController: view)

        defer {
            self.navigator = navigator
        }

        navigator.tabBarItem = UITabBarItem(
            title: String("Home", table: .common),
            image: Constant.defaultTabBarImage,
            selectedImage: Constant.selectedTabBarImage
        )

        navigator.tabBarItem.imageInsets = UIEdgeInsets(top: 2.0, left: .zero, bottom: .zero, right: .zero)
        
        return navigator
    }

    func advert(with id: Int, colorCode: String, dismiss completion: Callback<Bool>? = nil) {
        AdvertCoordinator().start(with: id, colorCode: colorCode, dismiss: completion)
    }

    func onboarding() {
        guard let tabBarController = UIApplication.tabBarController else { return }
        OnboardingCoordinator(navigator: tabBarController).start()
    }

    func chats() {
        ChatsCoordinator(navigator: navigator).start()
    }

    func filter(delegate: FilterViewModelDelegate, selectedFilters: FilterViewModel.Filters = .empty) {
        FilterCoordinator().start(navigatee: navigator, delegate: delegate, selectedFilters: selectedFilters)
    }
}

// MARK: - URLNavigatable

extension AdvertsCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        false
    }

    static var instance: any URLNavigatable {
        AdvertsCoordinator()
    }

    static func register(navigator: any URLNavigation) {
        navigator.register(coordinator: instance, pattern: .adverts) { _ in
            selectTab(tab: .home, shouldPopToRoot: true)
        }
    }
}
