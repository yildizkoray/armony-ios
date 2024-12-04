//
//  MusicGenreCell.swift
//  Armony
//
//  Created by Koray Yıldız on 24.01.2022.
//

import UIKit

class MusicGenreCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.makeAllCornersRounded(radius: .low)
    }

    func configure(with presentation: MusicGenreCellPresentation) {
        contentView.borderWidth = presentation.borderWidth
        contentView.borderColor = presentation.borderColor
        titleLabel.attributedText = presentation.item.title
    }
}
