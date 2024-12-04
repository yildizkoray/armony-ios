//
//  UIFont+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 21.11.2021.
//

import UIKit

public extension UIFont {

    var ct: CTFont {
        return self as CTFont
    }

    // MARK: - REGULAR

    /// 12
    static var regularBody: UIFont {
        return .poppins(.regular, size: .body)
    }

    /// 14
    static var regularSubheading: UIFont {
        return .poppins(.regular, size: .subheading)
    }

    /// 16
    static var regularHeading: UIFont {
        return .poppins(.regular, size: .heading)
    }

    /// 20
    static var regularTitle: UIFont {
        return .poppins(.regular, size: .title)
    }

    // MARK: - LIGHT

    /// 12
    static var lightBody: UIFont {
        return .poppins(.light, size: .body)
    }

    /// 14
    static var lightSubheading: UIFont {
        return .poppins(.light, size: .subheading)
    }

    /// 16
    static var lightHeading: UIFont {
        return .poppins(.light, size: .heading)
    }

    /// 20
    static var lightTitle: UIFont {
        return .poppins(.light, size: .title)
    }

    // MARK: - SEMIBOLD

    /// 12
    static var semiboldBody: UIFont {
        return .poppins(.semiBold, size: .body)
    }

    /// 14
    static var semiboldSubheading: UIFont {
        return .poppins(.semiBold, size: .subheading)
    }

    /// 16
    static var semiboldHeading: UIFont {
        return .poppins(.semiBold, size: .heading)
    }

    /// 20
    static var semiboldTitle: UIFont {
        return .poppins(.semiBold, size: .title)
    }

    static func poppins(_ type: AppTheme.Font, size: AppTheme.FontSize) -> UIFont {
        return UIFont(name: type.description, size: size.rawValue)!
    }

    static func poppins(_ type: AppTheme.Font, size: CGFloat) -> UIFont {
        return UIFont(name: type.description, size: size)!
    }
}
