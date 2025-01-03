//
//  UIButton+ActivityIndicatorView.swift
//  Armony
//
//  Created by Koray Yıldız on 15.02.2022.
//

import UIKit

public extension UIButton {

    private struct AssociationKeys {
        static var activityIndicatorView: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "button_activityIndicatorView".hashValue)!
        static var disabledTitle: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "button_disabledTitle".hashValue)!
        static var disabledAttributedTitle: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "button_disabledAttributedTitle".hashValue)!
        static var originalImage: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "button_originalImage".hashValue)!
    }

    private var image: UIImage? {
        get {
            return objc_getAssociatedObject(self, &AssociationKeys.originalImage) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &AssociationKeys.originalImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var disabledTitle: String? {
        get {
            return objc_getAssociatedObject(self, &AssociationKeys.disabledTitle) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociationKeys.disabledTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }


    private var disabledAttributedTitle: NSAttributedString? {
        get {
            return objc_getAssociatedObject(self, &AssociationKeys.disabledAttributedTitle) as? NSAttributedString
        }
        set {
            objc_setAssociatedObject(self, &AssociationKeys.disabledAttributedTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    override var activityIndicatorView: UIActivityIndicatorView {
        if let activityIndicatorView = objc_getAssociatedObject(
            self, &AssociationKeys.activityIndicatorView) as? UIActivityIndicatorView
        {
            return activityIndicatorView
        }

        let activityIndicatorView = UIActivityIndicatorView.create(color: .white, style: .medium)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(activityIndicatorView)

        NSLayoutConstraint.activate(
            [
                activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
                activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ]
        )

        objc_setAssociatedObject(self, &AssociationKeys.activityIndicatorView,
                                 activityIndicatorView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return activityIndicatorView
    }

    override func startActivityIndicatorView() {
        guard activityIndicatorView.isAnimating == false else { return }

        if let disabledTitle = title(for: .disabled) {
            self.disabledTitle = disabledTitle
        }

        if let disabledAttributedTitle = attributedTitle(for: .disabled) {
            self.disabledAttributedTitle = disabledAttributedTitle
        }

        if let image = image(for: .normal) {
            self.image = image
        }

        setImage(UIImage(), for: .disabled)
        setTitle(.empty, for: .disabled)
        setAttributedTitle(.empty, for: .disabled)
        
        isEnabled = false
        super.startActivityIndicatorView()
    }

    override func stopActivityIndicatorView() {
        guard activityIndicatorView.isAnimating else { return }

        isEnabled = true

        setImage(image, for: .normal)
        setTitle(disabledTitle, for: .disabled)
        setAttributedTitle(disabledAttributedTitle, for: .disabled)
        
        super.stopActivityIndicatorView()
    }
}
