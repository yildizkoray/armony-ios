//
//  UIColor+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 7.09.2021.
//

import UIKit

private struct Constants {
    static let numberOfHexDigit = 8
    static let defaultHexAlpha = "FF"
}

public extension UIColor {
    var alpha: CGFloat {
        var alpha: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return alpha
    }
    
    convenience init(r red: CGFloat, g green: CGFloat, b blue: CGFloat, a alpha: CGFloat = 1.0) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }

    convenience init(_ color: AppTheme.Color) {
        if color.isColorExist {
            self.init(named: color.description)!
        }
        else {
            self.init()
        }
    }

    convenience init(hex: String, alpha: CGFloat? = nil) {
        let red, green, blue: CGFloat
        let hexWithAlpha = hex + Constants.defaultHexAlpha

        if hexWithAlpha.hasPrefix(.hash) {
            let start = hexWithAlpha.index(hexWithAlpha.startIndex, offsetBy: 1)
            let hexColor = String(hexWithAlpha[start...])

            if hexColor.count == Constants.numberOfHexDigit {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = .zero

                if scanner.scanHexInt64(&hexNumber) {
                    red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255

                    self.init(red: red, green: green, blue: blue, alpha: alpha.ifNil(1.0))
                    return
                }
            }
        }
        self.init(ciColor: .clear)
    }
}

// MARK: - AppColors
public extension UIColor {
    // MARK: - Alpa
    /// 0.6
    static let armonyWhiteMedium: UIColor = .armonyWhite.withAlphaComponent(AppTheme.Alpha.medium.rawValue)
    /// 0.4
    static let armonyPurpleLow: UIColor = .armonyPurple.withAlphaComponent(AppTheme.Alpha.low.rawValue)
    /// 0.8
    static let armonyBlackHigh: UIColor = .armonyBlack.withAlphaComponent(AppTheme.Alpha.high.rawValue)
}
