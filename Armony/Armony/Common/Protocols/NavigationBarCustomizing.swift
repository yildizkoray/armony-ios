//
//  NavigationBarCustomizing.swift
//  Armony
//
//  Created by Koray Yıldız on 19.01.2022.
//

import UIKit

protocol NavigationBarCustomizing {
    func makeNavigationBarTransparent()
    func setNavigationBarBackgroundColor(color: UIColor)
    func setNavigationBarBackgroundColor(color: AppTheme.Color)
    func setNavigationBarTitleAttributes(_ attributes: [NSAttributedString.Key: Any])
    func setNavigationItemTitle(_ title: String)
    func setTitle(_ title: String)
    func setDismissButton(completion: VoidCallback?)
    func addNotch()
}

// MARK: - NavigationBarCustomizing + UIViewController
extension NavigationBarCustomizing where Self: UIViewController {

    private var appearances: [UINavigationBarAppearance] {
        guard let navigationController = navigationController else { return .empty}
        let standartAppearance = navigationController.navigationBar.standardAppearance
        navigationController.navigationBar.scrollEdgeAppearance = standartAppearance
        navigationController.navigationBar.compactAppearance = standartAppearance

        return [
            navigationController.navigationBar.standardAppearance,
            navigationController.navigationBar.scrollEdgeAppearance!,
            navigationController.navigationBar.compactAppearance!
        ]
    }

    func makeNavigationBarTransparent() {
        for appearance in appearances {
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
        }
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .clear
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }

    func setNavigationBarBackgroundColor(color: UIColor) {
        for appearance in appearances {
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = color
        }

        navigationController?.view.backgroundColor = color
        navigationController?.navigationBar.tintColor = color
        navigationController?.navigationBar.isTranslucent = false
    }

    func setNavigationBarBackgroundColor(color: AppTheme.Color) {
        setNavigationBarBackgroundColor(color: color.uiColor)
    }

    func setNavigationBarTitleAttributes(_ attributes: [NSAttributedString.Key: Any]) {
        for appearance in appearances {
            appearance.titleTextAttributes = attributes
        }
    }

    func setNavigationItemTitle(_ title: String) {
        navigationItem.title = title
    }

    func setTitle(_ title: String) {
        self.title = title
    }

    func setDismissButton(completion: VoidCallback?) {
        guard isPresentedViewController else { return }

        let button = UIButton(type: .system)
        button.setImage(.dismissCrossIcon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 32),
            button.heightAnchor.constraint(equalToConstant: 32)
        ])

        button.touchUpInsideAction = { [unowned self] _ in
            self.dismiss(animated: true, completion: completion)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    func addNotch() {
        guard isPresentedViewController,
              let navigationController = navigationController else { return }

        let notchView = NotchView()
        notchView.translatesAutoresizingMaskIntoConstraints = false
        navigationController.navigationBar.addSubview(notchView)
        NSLayoutConstraint.activate([
            notchView.centerXAnchor.constraint(equalTo: navigationController.navigationBar.centerXAnchor),
            notchView.topAnchor.constraint(equalTo: navigationController.navigationBar.topAnchor)
        ])
    }
}
