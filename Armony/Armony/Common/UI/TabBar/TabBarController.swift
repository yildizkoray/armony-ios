//
//  TabBarController.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import UIKit

final class TabBarController: UITabBarController {

    private let roundedTabBarView = UIView(frame: .zero)

    private var selectAccountClosure: VoidCallback?
    private var selectPlaceAdvertClosure: VoidCallback?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        selectAccountClosure = { [weak self] in
            self?.viewControllers?.element(at: Common.Tab.account.index)?.navigator?.popToRootViewController(animated: true)
            self?.selectedIndex = Common.Tab.account.index
        }

        selectPlaceAdvertClosure = { [weak self] in
            self?.viewControllers?.element(at: Common.Tab.placeAdvert.index)?.navigator?.popToRootViewController(animated: true)
            self?.selectedIndex = Common.Tab.placeAdvert.index
        }
    }

    override var viewControllers: [UIViewController]? {
        didSet {
            updateTabBarVisibility(viewControllers)
        }
    }

    private var _selectedTab: Common.Tab {
        guard let tab = Common.Tab(rawValue: selectedIndex) else {
            return .home
        }
        return tab
    }

    override var selectedIndex: Int {
        didSet {
            tabBar.tintColor = _selectedTab.tabBarColor.uiColor
        }
    }

    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        updateTabBarVisibility(viewControllers)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        updateTabBarVisibility(viewControllers)
    }

    private func updateTabBarVisibility(_ viewControllers: [UIViewController]?) {
        if let viewControllers = viewControllers {
            tabBar.isHidden = viewControllers.isEmpty
        }
        else {
            tabBar.isHidden = true
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        // TODO: - Burasi boyle olmaz. Junior bile boyle kod yazmaz. Please Fix It :)
        if !AuthenticationService.shared.isAuthenticated {
            if viewController == tabBarController.viewControllers?[Common.Tab.account.index] {
                RegistrationCoordinator().start(registrationCompletion: selectAccountClosure, loginCompletion: selectAccountClosure)
            }

            if viewController == tabBarController.viewControllers?[Common.Tab.placeAdvert.index] {
                RegistrationCoordinator().start(registrationCompletion: selectPlaceAdvertClosure, loginCompletion: selectPlaceAdvertClosure)
            }
            return false
        }

        guard tabBarController.selectedViewController == viewController else {
            return true
        }

        if let navigationController = viewController as? UINavigationController {
            if navigationController.viewControllers.count < 2 {
                TabBarItemScrollToTopFirebaseEvent().send()
                navigationController.rootViewController?.scrollToTop(animated: true)
            }
        }
        else {
            viewController.scrollToTop(animated: true)
        }

        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tabBar.tintColor = _selectedTab.tabBarColor.uiColor
    }
}

// MARK: - TabBarItemScrollToTopFirebaseEvent
struct TabBarItemScrollToTopFirebaseEvent: FirebaseEvent {
    var name: String = "scroll_to_top_on_home"
    var action: String = "Scroll"
    var category: String = "Home"
}
