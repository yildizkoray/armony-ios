//
//  EmptyStateShowing.swift
//  Armony
//
//  Created by Koray Yildiz on 17.05.22.
//

import UIKit

private struct AssociationKeys {
    static var emptyStateView: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "ui_emptyStateView".hashValue)!
}

protocol EmptyStateShowing {

    var containerEmptyStateView: UIView { get }
    var emptyStateView: EmptyStateView { get }

    func hideEmptyStateView(animated: Bool)
    func showEmptyStateView(with presentation: EmptyStatePresentation, action: Callback<UIButton>?)
}

extension EmptyStateShowing {

    var emptyStateView: EmptyStateView {
        if let emptyStateView = objc_getAssociatedObject(self, &AssociationKeys.emptyStateView) as? EmptyStateView {
            return emptyStateView
        }

        let emptyStateView = EmptyStateView(frame: .zero)
        emptyStateView.isHidden = true
        containerEmptyStateView.addSubview(emptyStateView)
        containerEmptyStateView.addSubviewAndConstraintsToEdges(emptyStateView)

        objc_setAssociatedObject(self, &AssociationKeys.emptyStateView, emptyStateView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return emptyStateView
    }

    func hideEmptyStateView(animated: Bool) {
        containerEmptyStateView.sendSubviewToBack(emptyStateView)
        emptyStateView.setHidden(true, animated: animated)
    }

    func showEmptyStateView(with presentation: EmptyStatePresentation, action: Callback<UIButton>? = nil) {
        containerEmptyStateView.bringSubviewToFront(emptyStateView)

        emptyStateView.configure(with: presentation, action: action)
        emptyStateView.setHidden(false, animated: true)
    }
}

