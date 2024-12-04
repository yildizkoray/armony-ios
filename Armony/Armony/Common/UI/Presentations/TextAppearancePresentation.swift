//
//  TextAppearancePresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 21.11.2021.
//

import UIKit

public final class TextAppearancePresentation {

    public let color: UIColor
    public let font: UIFont

    public convenience init(color: AppTheme.Color, font: UIFont) {
        self.init(color.uiColor, font: font)
    }

    public init(_ color: UIColor, font: UIFont) {
        self.color = color
        self.font = font
    }

    private init() {
        color = .clear
        font = UIFont()
    }

    // MARK: - EMPTY
    public static let empty = TextAppearancePresentation()
}
