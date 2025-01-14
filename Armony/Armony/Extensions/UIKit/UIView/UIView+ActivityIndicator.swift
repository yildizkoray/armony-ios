//
//  UIView+ActivityIndicator.swift
//  Armony
//
//  Created by Koray Yıldız on 15.11.2021.
//

import UIKit

extension UIView {

    private struct AssociationKeys {
        static var activityIndicatorView: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "armony_activityIndicatorView".hashValue)!
    }

    @objc var activityIndicatorView: UIActivityIndicatorView {
        if let view = objc_getAssociatedObject(self, &AssociationKeys.activityIndicatorView) as? UIActivityIndicatorView {
            return view
        }

        let activityIndicatorView = UIActivityIndicatorView.create(color: .white)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addConstraints(NSLayoutConstraint.constraints(
                        withVisualFormat: "V:|->=8@999-[activityIndicatorView]->=8@999-|",
                        options: [],
                        metrics: [:],
                        views: ["activityIndicatorView": activityIndicatorView]))

        objc_setAssociatedObject(self, &AssociationKeys.activityIndicatorView,
                                 activityIndicatorView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return activityIndicatorView
    }
}

// MARK: - ActivityIndicatorShowing
extension UIView: ActivityIndicatorShowing {
    @objc func startActivityIndicatorView() {
        activityIndicatorView.startAnimating()
    }

    @objc func stopActivityIndicatorView() {
        activityIndicatorView.stopAnimating()
    }
}
