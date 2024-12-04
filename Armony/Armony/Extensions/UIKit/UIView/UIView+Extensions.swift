//
//  UIView+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 23.08.2021.
//

import UIKit

public extension UIView {

    func setHidden(_ isHidden: Bool, animated: Bool = true, completion: Callback<Bool>? = nil) {
        guard self.isHidden != isHidden else { return }

        if animated {
            UIView.transition(
                with: self,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: { self.isHidden = isHidden },
                completion: completion
            )
        }
        else {
            self.isHidden = isHidden
            completion?(true)
        }
    }

    func addSubviewAndConstraintsToEdges(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),

            view.widthAnchor.constraint(equalTo: widthAnchor),
            view.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }

    func addSubviewAndConstraintsToEdges(_ view: UIView, insets: UIEdgeInsets) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
        ])
    }

    func addSubviewAndConstraintsToSafeArea(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    func circled() {
        makeCornersRounded(radius: frame.width / 2, CALayer.allCorners)
    }

    func makeBordered(width: AppTheme.Border = .default, color: AppTheme.Color, alpha: AppTheme.Alpha = .default) {
        borderColor = color.uiColor.withAlphaComponent(alpha.rawValue)
        borderWidth = width.rawValue
    }

    func makeCornersRounded(radius: AppTheme.Radius, _ corners: CACornerMask) {
        makeCornersRounded(radius: radius.rawValue, corners)
    }

    func makeAllCornersRounded(radius: AppTheme.Radius) {
        makeCornersRounded(radius: radius, CALayer.allCorners)
    }

    func makeCornersRounded(radius: CGFloat, _ corners: CACornerMask) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }

    func subviews<T>(ofType type: T.Type) -> [T] {
        var result = [T]()
        var stack = Array(subviews.reversed())

        while !stack.isEmpty {
            let view = stack.removeLast()
            stack.append(contentsOf: view.subviews.reversed())

            if let aView = view as? T {
                result.append(aView)
            }
        }
        return result
    }

    func setAlpha(_ alpha: AppTheme.Alpha) {
        self.alpha = alpha.rawValue
    }

    func setBackgroundColor(_ color: AppTheme.Color) {
        self.backgroundColor = color.uiColor
    }
}
