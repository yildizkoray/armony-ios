//
//  SkillCell.swift
//  Armony
//
//  Created by Koray Yıldız on 8.10.2021.
//

import UIKit

final class SkillCell: UICollectionViewCell {

    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    func configure(with presentation: SkillCellPresentation) {
        containerStackView.axis = presentation.axis
        containerStackView.spacing = presentation.spacing

        imageContainerViewWidthConstraint.constant = presentation.imageViewContainerViewWidth
        imageContainerView.backgroundColor = presentation.imageContainerViewColor
        imageContainerView.addSubviewAndConstraintsToEdges(imageView, insets: UIEdgeInsets(edges: presentation.inset))
        imageContainerView.makeCornersRounded(
            radius: presentation.imageViewContainerViewWidth / 2, [CALayer.rightCorners, .layerMinXMinYCorner]
        )
        imageView.setImage(source: .url(presentation.skill.iconURL))

        imageContainerView.borderWidth = presentation.imageContainerViewBorderWidth.ifNil(.zero)
        imageContainerView.borderColor = presentation.imageContainerViewBorderColor

        titleLabel.attributedText = presentation.skill.title
    }
}
