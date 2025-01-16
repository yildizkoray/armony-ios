//
//  UIApplication+Extensions.swift
//  Armony
//
//  Created by Koray Yildiz on 20.06.22.
//

import UIKit

public extension UIApplication {

    static var window: UIWindow? {
        guard let scene = Self.topMostScene as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        return window
    }

    static var topMostScene: UIScene? {
        return scene
    }

    private static var scene: UIScene? {
        let foregroundActiveScene = shared.connectedScenes.first(where: { $0.activationState == .foregroundActive })
        let foregroundInactiveScene = shared.connectedScenes.first(where: { $0.activationState == .foregroundInactive })
        let backgroundScene = shared.connectedScenes.first(where: { $0.activationState == .background })

        return foregroundActiveScene ?? foregroundInactiveScene ?? backgroundScene
    }

    static var safeAreaInsets: UIEdgeInsets {
        return window?.safeAreaInsets ?? .zero
    }

    static var tabBarController: UITabBarController? {
        return window?.rootViewController as? UITabBarController
    }
}
