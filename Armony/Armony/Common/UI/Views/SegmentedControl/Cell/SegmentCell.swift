//
//  SegmentCell.swift
//  Armony
//
//  Created by Koray Yıldız on 08.10.22.
//

import UIKit

final class SegmentCell: UICollectionViewCell {

    @IBOutlet private weak var bottomLineView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    func configure(title: String, style appearance: TextAppearancePresentation) {
        titleLabel.text = title
        titleLabel.font = appearance.font
        titleLabel.textColor = appearance.color
    }

    func select(color: UIColor) {
        bottomLineView.backgroundColor = color
        bottomLineView.isHidden = false
    }

    func deselect() {
        bottomLineView.isHidden = true
    }
}
