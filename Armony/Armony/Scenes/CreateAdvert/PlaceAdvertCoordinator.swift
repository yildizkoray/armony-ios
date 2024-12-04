//
//  PlaceAdvertCoordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 05.10.22.
//

import UIKit

final class PlaceAdvertCoordinator: Coordinator {

    typealias Controller = PlaceAdvertViewController

    weak var navigator: Navigator?

    func start() -> UIViewController {
        let view = createViewController()
        let navigator = Navigator(rootViewController: view)
        let viewModel = PlaceAdvertViewModel(view: view)
        viewModel.coordinator = self

        defer {
            self.navigator = navigator
        }

        view.viewModel = viewModel

        navigator.tabBarItem = UITabBarItem(
            title: String("TabBarTitle", table: .placeAdvert),
            image: .tabCreateAdvertDefaultIcon,
            selectedImage: .tabCreateAdvertSelectedIcon
        )

        navigator.tabBarItem.imageInsets = .init(top: 2, left: .zero, bottom: .zero, right: .zero)

        return navigator
    }

    func profileSelection(presentation: any SelectionPresentation) {
        SelectionBottomPopUpCoordinator(navigator: navigator).start(presentation: presentation)
    }
}

// MARK: - URLNavigatable
extension PlaceAdvertCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return true
    }
    
    static var instance: any URLNavigatable {
        return PlaceAdvertCoordinator()
    }
    
    static func register(navigator: any URLNavigation) {
        navigator.register(coordinator: instance, pattern: .placeAdvert) { _ in
            selectTab(tab: .placeAdvert, shouldPopToRoot: true)
        }
    }

}
