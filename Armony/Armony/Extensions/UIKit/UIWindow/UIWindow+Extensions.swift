//
//  UIWindow+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 9.02.2022.
//

import UIKit

public extension UIWindow {

    func setRootViewController(_ viewController: UIViewController, animated: Bool) {

        if animated, let oldView = snapshotView(afterScreenUpdates: true) {
            viewController.view.alpha = .zero
            rootViewController = viewController

            addSubviewAndConstraintsToEdges(oldView)

            UIView.animate(withDuration: 0.25,
                           delay: .zero,
                           options: UIView.AnimationOptions.curveLinear) {
                viewController.view.alpha = 1.0
                oldView.alpha = .zero
            } completion: { _ in
                oldView.removeFromSuperview()
            }
        }
        else {
            rootViewController = viewController
        }
    }
}
