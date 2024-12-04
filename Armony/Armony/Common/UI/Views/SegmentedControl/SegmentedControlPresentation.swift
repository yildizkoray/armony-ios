//
//  SegmentedControlPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 09.10.22.
//

import UIKit

struct SegmentedControlPresentation {

    let items: [String]
    let selectedIndex: Int
    let selectedColor: UIColor
    let textAppearance: TextAppearancePresentation

    init(items: [String],
         selectedIndex: Int = .zero,
         selectedColor: UIColor = .armonyPurple,
         textAppearance: TextAppearancePresentation = .segmentControl) {
        self.items = items
        self.selectedIndex = selectedIndex
        self.selectedColor = selectedColor
        self.textAppearance = textAppearance
    }

    // MARK: - EMPTY
    static let empty = SegmentedControlPresentation(items: .empty, textAppearance: .empty)
}

// MARK: - TextAppearancePresentation
extension TextAppearancePresentation {
    static var segmentControl: TextAppearancePresentation {
        return TextAppearancePresentation(color: .white, font: .regularBody)
    }
}
