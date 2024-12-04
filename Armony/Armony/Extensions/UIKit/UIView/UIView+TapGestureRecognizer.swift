//
//  UIView+TapGesture.swift
//  Armony
//
//  Created by Koray Yıldız on 30.01.2022.
//

import UIKit

public extension UIView {

    private struct AssociationKeys {
        static var tapGestureRecognizer = "tapGestureRecognizer"
        static var tapGestureRecognizerAction = "tapGestureRecognizerAction"
    }

    private var action: Callback<UIView>? {
        get {
            return objc_getAssociatedObject(self, &AssociationKeys.tapGestureRecognizerAction) as? Callback<UIView>
        }
        set {
            objc_setAssociatedObject(self, &AssociationKeys.tapGestureRecognizerAction, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }

    private var tapGestureRecognizer: UITapGestureRecognizer {
        if let tapGestureRecognizer = objc_getAssociatedObject(self, &AssociationKeys.tapGestureRecognizer)
            as? UITapGestureRecognizer
        {
            return tapGestureRecognizer
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))

        objc_setAssociatedObject(
            self,
            &AssociationKeys.tapGestureRecognizer,
            tapGestureRecognizer,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        return tapGestureRecognizer
    }

    func addTapGestureRecognizer(cancelsTouches: Bool = true, action: @escaping Callback<UIView>) {
        self.action = action
        tapGestureRecognizer.cancelsTouchesInView = cancelsTouches

        isUserInteractionEnabled = true
        addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func tapped() {
        action?(self)
    }
}
