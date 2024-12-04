//
//  UIButton+Extensions.swift
//  Armony
//
//  Created by Koray Yildiz on 12.05.22.
//

import UIKit

public extension UIButton {

    // MARK: RoundedConfiguration
    struct RoundedConfiguration {
        let radius: AppTheme.Radius
        let corners: CACornerMask

        init(radius: AppTheme.Radius, corners: CACornerMask = CALayer.allCorners) {
            self.radius = radius
            self.corners = corners
        }
    }

    // MARK: BorderConfiguration
    struct BorderConfiguration {
        let radius: AppTheme.Border
        let color: AppTheme.Color

        init(radius: AppTheme.Border, color: AppTheme.Color = .clear) {
            self.radius = radius
            self.color = color
        }
    }

    // MARK: Config
    struct Config {
        let title: String
        let titleColor: AppTheme.Color
        let titleFont: UIFont
        let backgroundColor: AppTheme.Color
        let rounded: RoundedConfiguration?
        let border: BorderConfiguration?

        init(title: String,
             titleColor: AppTheme.Color,
             titleFont: UIFont,
             backgroundColor: AppTheme.Color,
             rounded: RoundedConfiguration? = nil,
             border: BorderConfiguration? = nil) {
            self.title = title
            self.titleColor = titleColor
            self.titleFont = titleFont
            self.backgroundColor = backgroundColor
            self.rounded = rounded
            self.border = border
        }
    }

    func setHidableAttributedTitle(_ title: NSAttributedString?, state: UIControl.State) {
        setAttributedTitle(title, for: state)
        isHidden = title.isNil
    }

    func configure(with configuration: Config) {
        setTitle(configuration.title, for: .normal)
        setTitleColor(configuration.titleColor.uiColor, for: .normal)
        titleLabel?.font = configuration.titleFont
        backgroundColor = configuration.backgroundColor.uiColor

        if let rounded = configuration.rounded {
            makeCornersRounded(radius: rounded.radius, rounded.corners)
        }

        if let border = configuration.border {
            makeBordered(width: border.radius, color: border.color)
        }
    }
}

public extension UIButton {

    private struct AssociationKeys {
        static var touchUpInsideBlock = "armony_button_touchUpInsideBlock"
    }

    var touchUpInsideAction: Callback<UIButton>? {
        get {
            return objc_getAssociatedObject(self, &AssociationKeys.touchUpInsideBlock) as? Callback<UIButton>
        }
        set {
            removeTarget(self, action: #selector(touchUpInsideActionTriggered), for: .touchUpInside)
            addTarget(self, action: #selector(touchUpInsideActionTriggered), for: .touchUpInside)

            objc_setAssociatedObject(self, &AssociationKeys.touchUpInsideBlock, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    @objc private func touchUpInsideActionTriggered() {
        touchUpInsideAction?(self)
    }
}

