//
//  UIApplication+Extensions.swift
//  Armony
//
//  Created by Koray Yildiz on 20.06.22.
//

import UIKit

public extension UIApplication {

    static var window: UIWindow? {
        guard let window = Self.shared.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        return window
    }

    static var safeAreaInsets: UIEdgeInsets {
        return window?.safeAreaInsets ?? .zero
    }

    static var tabBarController: UITabBarController? {
        return window?.rootViewController as? UITabBarController
    }
}
