//
//  Coordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 22.08.2021.
//

import UIKit
import SwiftUI
import SafariServices

public typealias Navigator = UINavigationController

public protocol Coordinator {

    associatedtype Controller: ViewController

    var navigator: Navigator? { get }

    func createViewController() -> Controller
    func createNavigatorWithRootViewController() -> (navigator: Navigator, view: Controller)
    
    func dismiss(animated: Bool, completion: VoidCallback?)
    func pop(animated: Bool)
    func popToRootViewController(animated: Bool)
}

public extension Coordinator where Controller: UIViewController {

    var navigator: Navigator? {
        return UIViewController.topMostNavigationController
    }

    func createViewController() -> Controller {
        return Controller.controller()
    }

    func createNavigationController() -> Navigator {
        return Controller.navigator()
    }

    func createNavigatorWithRootViewController() -> (navigator: Navigator, view: Controller) {
        let navigator = createNavigationController()
        let view = navigator.rootViewController as! Controller
        return (navigator: navigator, view: view)
    }

    func dismiss(animated: Bool = true, completion: VoidCallback? = nil) {
        navigator?.dismiss(animated: animated, completion: completion)
    }

    func pop(animated: Bool = true) {
        navigator?.popViewController(animated: animated)
    }

    func popToRootViewController(animated: Bool) {
        navigator?.popToRootViewController(animated: animated)
    }

    @discardableResult
    func selectTab(tab: Common.Tab, shouldPopToRoot: Bool = false) -> UIViewController? {
        let tabBarController = UIApplication.tabBarController
        let tabBarControllerViewControllers = UIApplication.tabBarController?.viewControllers

        tabBarController?.selectedIndex = tab.index
        if shouldPopToRoot {
            tabBarControllerViewControllers?.element(at: tab.index)?.navigator?.popToRootViewController(animated: true)
        }
        return tabBarControllerViewControllers?.element(at: tab.index)?.navigator?.rootViewController
    }

    @discardableResult
    static func selectTab(tab: Common.Tab, shouldPopToRoot: Bool = false) -> UIViewController? {
        let tabBarController = UIApplication.tabBarController
        let tabBarControllerViewControllers = UIApplication.tabBarController?.viewControllers

        tabBarController?.selectedIndex = tab.index
        if shouldPopToRoot {
            tabBarControllerViewControllers?.element(at: tab.index)?.navigator?.popToRootViewController(animated: true)
        }
        return tabBarControllerViewControllers?.element(at: tab.index)?.navigator?.rootViewController
    }
}

extension Coordinator {

    var urlNavigator: URLNavigation {
        return URLNavigator.shared
    }

    func open(deeplink: Deeplink) {
        urlNavigator.open(deeplink)
    }

    func open(url: URL) {
        UIApplication.shared.open(url)
    }

    func open(urlString: String) {
        if let url = URL(string: urlString) {
            open(url: url)
        }
    }

    func openAtSafariViewController(url: URL) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true

        let view = SFSafariViewController(url: url, configuration: config)
        navigator.ifNil(UIViewController.topMostViewController as! Navigator).present(view, animated: true)
    }
}

// MARK: - UINavigationController
extension UINavigationController {

    var rootViewController: UIViewController! {
        viewControllers.first
    }
}

protocol SwiftUICoordinator: Coordinator {
    associatedtype Content: View
}

extension SwiftUICoordinator where Controller == UIHostingController<Content> {

    func createHostingViewController(rootView: any View) -> Controller {
        let hosting = Controller.hosting(rootView: rootView)
        hosting.view.backgroundColor = .armonyBlack
        return hosting
    }
}

extension UIHostingController: ViewController {
    public static var storyboardName: UIStoryboard.Name {
        .hosting
    }
}
