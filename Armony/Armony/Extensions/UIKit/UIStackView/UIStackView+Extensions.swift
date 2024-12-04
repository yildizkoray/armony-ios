//
//  UIStackView+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 22.11.22.
//

import UIKit

public extension UIStackView {
    struct Configuration {
        let spacing: AppTheme.Spacing
        let axis: NSLayoutConstraint.Axis
        let layoutMargins: UIEdgeInsets?
        let alligment: Alignment
        let distribution: Distribution


        /// Init func
        /// - Parameters:
        ///   - spacing: Spacing
        ///   - axis: Default `horizontal`
        ///   - layoutMargins: Default `nil`
        ///   - alligment: Default `.fill`
        ///   - distribution: Default `.fill`
        init(spacing: AppTheme.Spacing,
             axis: NSLayoutConstraint.Axis = .horizontal,
             layoutMargins: UIEdgeInsets? = nil,
             alligment: Alignment = .fill,
             distribution: Distribution = .fill) {
            self.spacing = spacing
            self.axis = axis
            self.layoutMargins = layoutMargins
            self.alligment = alligment
            self.distribution = distribution
        }
    }

    convenience init(arrangedSubviews: [UIView] = .empty, config: UIStackView.Configuration) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.configure(with: config)
    }

    func addArrangedSubviews(_ views: UIView...) {
        for subview in views {
            addArrangedSubview(subview)
        }
    }

    func setCustomSpacing(spacing: AppTheme.Spacing, afterView: UIView) {
        setCustomSpacing(spacing.rawValue, after: afterView)
    }
}

// MARK: - Privates
private extension UIStackView {
    private func configure(with config: Configuration) {
        spacing = config.spacing.rawValue
        axis = config.axis
        alignment = config.alligment
        distribution = config.distribution
        if let layoutMargins = config.layoutMargins {
            isLayoutMarginsRelativeArrangement = true
            self.layoutMargins = layoutMargins
        }
    }
}
