//
//  ViewController.swift
//  Armony
//
//  Created by Koray Yıldız on 22.08.2021.
//

import UIKit
import SwiftUI

private struct Constants {
    static let seperator = "ViewController"
}

public protocol ViewController {
    static var storyboardName: UIStoryboard.Name { get }
}

extension ViewController where Self: UIViewController {

    static func allocate<V: UIViewController>(suffix: String) -> V {
        guard let identifier = "\(self)".components(separatedBy: Constants.seperator).first else {
            preconditionFailure("Unable to initiliaze view controller with name \(self)")
        }
        return StoryboardLoader.shared.board(with: storyboardName).allocate(with: identifier + suffix)
    }

    static func controller() -> Self {
        if storyboardName == .none {
            return Self()
        }
        return allocate(suffix: .empty)
    }

    static func navigator() -> Navigator {
        if storyboardName == .none {
            return Navigator(rootViewController: controller())
        }
        return allocate(suffix: "Navigator")
    }

    static func hosting<T: View >(rootView: T) -> Self {
        return UIHostingController(rootView: rootView) as! Self
    }
}

extension FirebaseManuelScreenViewing where Self: UIViewController {
    func trackScreenView(parameters: FirebaseEvent.Payload = .empty) {
        guard let sceneName = Self.className.components(separatedBy: Constants.seperator).first else {
            preconditionFailure("Unable to parse view controller with name \(self)")
        }
        FirebaseManuelScreenViewEvent(scene: sceneName, sceneClassName: Self.className, parameters: parameters).send()
    }
}

extension UIViewController: FirebaseManuelScreenViewing { }
