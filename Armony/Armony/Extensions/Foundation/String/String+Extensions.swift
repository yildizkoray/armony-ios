//
//  String+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 22.08.2021.
//

import Foundation
import UIKit

public extension String {

    static let empty = ""
    static let space = " "
    static let comma = ","
    /// =
    static let equalSign = "="
    /// &
    static let ampersand = "&"
    /// #
    static let hash = "#"
    /// -
    static let hyphen = "-"
    /// /
    static let slash = "/"
    /// /
    static let newLine = "\n"

    var appColor: AppTheme.Color {
        return AppTheme.Color(rawValue: self)!
    }

    var colorFromHEX: UIColor {
        return UIColor(hex: self)
    }

    var image: UIImage {
        return UIImage(named: self) ?? UIImage()
    }

    var imageView: UIImageView {
        return UIImageView(image: image)
    }

    var isNotEmpty: Bool {
        return !isEmpty
    }

    var titled: String {
        return prefix(1).capitalized + dropFirst()
    }

    init(_ key: String, table: Localization.Table) {
        self.init(localized: LocalizationValue(key), table: table.description)
    }

    init(_ key: String.LocalizationValue, table: Localization.Table) {
        self.init(localized: key, table: table.description)
    }

    func localized(table: Localization.Table) -> String {
        String(self, table: table)
    }

    func attributed(_ color: UIColor, font: UIFont) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [.foregroundColor: color,
                                                             .font: font])
    }

    func attributed(color: AppTheme.Color, font: UIFont) -> NSAttributedString {
        return attributed(color.uiColor, font: font)
    }

    var emptyStateTitleAttributed: NSAttributedString {
        return attributed(color: .white, font: .regularSubheading)
    }

    var emptyStateSubtitleAttributed: NSAttributedString {
        return attributed(color: .white, font: .regularBody)
    }

    var emptyStateButtonAttributed: NSAttributedString {
        return attributed(color: .white, font: .semiboldHeading)
    }


}

// MARK: - AppColor - HEX
public extension String {
    static let blackColor = "#0E012A"
    static let darkBlueColor = "#17214E"
    static let whiteColor = "#FAFAFA"
    static let blueColor = "#9EF3FF"
    static let pinkColor = "#E64980"
    static let purpleColor = "#7B61FF"
    static let darkPurpleColor = "#670CB3"
    static let redColor = "#FF3B30"
    static let greenColor = "#B2F2BB"
}

extension String {
    
    @available(*, deprecated, message: "TODO: Localization")
    var needLocalization: String {
        "\(self)"
    }
}
