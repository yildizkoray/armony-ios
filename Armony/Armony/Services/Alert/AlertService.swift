//
//  AlertService.swift
//  Armony
//
//  Created by Koray Yıldız on 15.02.2022.
//

import UIKit

public final class AlertService {

    public enum Style {
        case `default`
        case cancel
        case destructive

        var toUIKit: UIAlertAction.Style {
            switch self {
            case .cancel:
                return .cancel

            case .destructive:
                return .destructive

            case .default:
                return .default
            }
        }
    }

    public class func show(error: APIError?,
                           actions: [UIAlertAction],
                           onto view: UIViewController? = nil) {
        show(title: .empty, message: error.ifNil(.noData).description, actions: actions, onto: view)
    }

    public class func show(title: String = .empty,
                           message: String,
                           actions: [UIAlertAction],
                           inputPlaceholder: String? = nil,
                           textFieldDelegate: UITextFieldDelegate? = nil,
                           onto view: UIViewController? = nil) {
        safeSync {
            if let view = view ?? UIViewController.topMostViewController {
                let alert = UIAlertController(title: title.isEmpty ? Common.instrumentEmojis.randomElement()! : title,
                                              message: message,
                                              actions: actions)

                if let inputPlaceholder {
                    alert.addTextField { textField in
                        textField.keyboardType = .URL
                        textField.placeholder = inputPlaceholder
                        textField.delegate = textFieldDelegate
                    }
                }
                view.present(alert, animated: true)
            }
        }
    }

    public class func action(title: String, style: AlertService.Style = .default, action: @escaping VoidCallback) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style.toUIKit) { _ in
            action()
        }
        return action
    }

    public class func actionSheet(title: String? = nil,
                                  message: String? = nil,
                                  sourceView: UIView?,
                                  actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = sourceView
            alert.popoverPresentationController?.sourceRect = sourceView?.bounds ?? .zero
            alert.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        actions.forEach {
            alert.addAction($0)
        }
        return alert
    }
}

extension UIAlertController {
    convenience init(title: String, message: String, actions: [UIAlertAction]) {
        self.init(title: title, message: message, preferredStyle: .alert)
        actions.forEach {
            addAction($0)
        }
    }
}

extension UIAlertAction {
    class func okay(action: VoidCallback? = nil) -> UIAlertAction {
        let title = String(localized: "Common.OK", table: "Common+Localizable")
        return UIAlertAction(title: title, style: .default) { _ in
            action?()
        }
    }

    class func cancel(action: VoidCallback? = nil) -> UIAlertAction {
        let title = String(localized: "Common.Cancel", table: "Common+Localizable")
        return UIAlertAction(title: title, style: .cancel) { _ in
            action?()
        }
    }
}



extension UIAlertController {
    public func show(onto view: UIViewController,
                     animated: Bool = true,
                     completion: VoidCallback? = nil) {
        view.present(self, animated: animated, completion: completion)
    }
}
