//
//  AppCoordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 22.08.2021.
//

import UIKit

final class AppCoordinator {

    private let window: UIWindow
    private let tabBarController: TabBarController

    init(window: UIWindow) {
        self.window = window
        tabBarController = TabBarController()
    }

    func startAsArmony() {
        configureTabBarContent()
        window.setRootViewController(tabBarController, animated: true)
    }

    func configureTabBarContent() {
        var viewControllers: [UIViewController] = .empty

        viewControllers.insert(AdvertsCoordinator().start(), at: Common.Tab.home.index)
        viewControllers.insert(PlaceAdvertCoordinator().start(), at: Common.Tab.placeAdvert.index)
        viewControllers.insert(AccountCoordinator().start(), at: Common.Tab.account.index)

        tabBarController.setViewControllers(viewControllers, animated: false)
        tabBarController.tabBarController(tabBarController, didSelect: viewControllers.first!)
    }

    func start() {
        SplashCoordinator(window: window).start()
        window.makeKeyAndVisible()
    }
}
