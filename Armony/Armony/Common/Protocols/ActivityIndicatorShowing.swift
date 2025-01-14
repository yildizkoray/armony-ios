//
//  ActivityIndicatorShowing.swift
//  Armony
//
//  Created by Koray Yıldız on 18.11.2021.
//

import UIKit

private struct AssociationKeys {
    static var activityIndicatorView: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "armony_rightBar_ActivityIndicator".hashValue)!
    static var rightBarButtonItem: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "armony_rightBar_Button".hashValue)!
}

protocol ActivityIndicatorShowing {
    
    func startActivityIndicatorView()
    func stopActivityIndicatorView()
}

// MARK: - ActivityIndicatorShowing + UIViewController
extension ActivityIndicatorShowing where Self: UIViewController {

    func startActivityIndicatorView() {
        view.activityIndicatorView.startAnimating()
    }

    func stopActivityIndicatorView() {
        view.activityIndicatorView.stopAnimating()
    }
}

// MARK: - NavigationBarActivityIndicatorShowing + UIViewController
protocol NavigationBarActivityIndicatorShowing {

    func startRightBarButtonItemActivityIndicatorView()
    func stopRightBarButtonItemActivityIndicatorView()
}

// MARK: - NavigationBarActivityIndicatorShowing + UIViewController
extension NavigationBarActivityIndicatorShowing where Self: UIViewController {

    private var activityIndicatorView: UIActivityIndicatorView {
        if let view = objc_getAssociatedObject(self, &AssociationKeys.activityIndicatorView) as? UIActivityIndicatorView {
            return  view
        }

        let activityIndicatorView = UIActivityIndicatorView.create(color: AppTheme.Color.white.uiColor)
        activityIndicatorView.hidesWhenStopped = true

        objc_setAssociatedObject(self, &AssociationKeys.activityIndicatorView, activityIndicatorView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return activityIndicatorView
    }

    private var rightBarButtonItem: UIBarButtonItem? {
        get {
            return objc_getAssociatedObject(self, &AssociationKeys.rightBarButtonItem) as? UIBarButtonItem
        }
        set {
            objc_setAssociatedObject(self, &AssociationKeys.rightBarButtonItem, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func startRightBarButtonItemActivityIndicatorView() {
        if navigationItem.rightBarButtonItem?.customView != activityIndicatorView {
            rightBarButtonItem = navigationItem.rightBarButtonItem
        }

        activityIndicatorView.alpha = 1.0
        activityIndicatorView.subviews(ofType: UIImageView.self).forEach { $0.alpha = 1.0 }

        activityIndicatorView.startAnimating()

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
    }

    func stopRightBarButtonItemActivityIndicatorView() {
        if activityIndicatorView.isAnimating {
            activityIndicatorView.stopAnimating()
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }
}

