//
//  UIViewController+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 28.08.2021.
//

import UIKit

extension UIViewController {

    var navigator: Navigator? {
        return navigationController ?? self as? Navigator
    }

    var isPresentedViewController: Bool {
        if presentingViewController?.presentedViewController == self {
            return true
        }
        else if navigationController != nil &&
                    navigationController?.presentingViewController?.presentedViewController == navigationController &&
                    navigationController?.viewControllers.first == self
        {
            return true
        }
        else if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        else {
            return false
        }
    }

    class var topMostViewController: UIViewController? {
        var rootViewController: UIViewController?
        
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = scene.windows.first(where: { $0.isKeyWindow }) {
            rootViewController = window.rootViewController
        }
        
        return topMostViewController(of: rootViewController)
    }

    func dismissToRootViewController(animated: Bool, completion: (() -> Void)? = nil) {
        view.window?.rootViewController?.dismiss(animated: animated, completion: completion)
    }

    class func topMostViewController(of viewController: UIViewController?) -> UIViewController? {

        //         presented view controller
        if let presentedViewController = viewController?.presentedViewController,
           !(presentedViewController is UISearchController) {
            return topMostViewController(of: presentedViewController)
        }

        //         UITabBarController
        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return topMostViewController(of: selectedViewController)
        }

        //         UINavigationController
        if let navigationController = viewController as? Navigator,
           let visibleViewController = navigationController.visibleViewController {
            return topMostViewController(of: visibleViewController)
        }

        //         UIPageController
        if let pageViewController = viewController as? UIPageViewController,
           pageViewController.viewControllers?.count == 1 {
            return topMostViewController(of: pageViewController.viewControllers?.first)
        }

        //         Child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return topMostViewController(of: childViewController)
            }
        }

        return viewController
    }

    class var topMostNavigationController: Navigator? {

        let topMostViewController = self.topMostViewController

        if let navigationController = topMostViewController as? Navigator {
            return navigationController
        }
        else {
            return topMostViewController?.navigationController
        }
    }

    func scrollToTop(animated: Bool) {
        view
            .subviews(ofType: UIScrollView.self)
            .first{ $0.direction == .vertical && $0.scrollsToTop }?
            .scrollToTop(animated: animated)
    }
}

