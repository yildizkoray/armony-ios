//
//  UILabel+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 21.01.2022.
//

import UIKit

public extension UILabel {

    var hidableText: String? {
        set {
            text = newValue
            isHidden = newValue.ifNil(.empty).isEmpty
        }
        get {
            return text
        }
    }

    var hidableAttributedText: NSAttributedString? {
        set {
            attributedText = newValue
            isHidden = newValue.ifNil(NSAttributedString(string: .empty)).string.isEmpty
        }
        get {
            return attributedText
        }
    }

    func configure(font: UIFont, color textColor: UIColor) {
        self.font = font
        self.textColor = textColor
    }
}
