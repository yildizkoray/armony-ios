//
//  OnboardingCollectionViewCell.swift
//  Armony
//
//  Created by Koray Yildiz on 13.06.22.
//

import UIKit

final class OnboardingCell: UICollectionViewCell {

    @IBOutlet private weak var contentImageView: UIImageView!
    @IBOutlet private weak var borderImageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!

    func configure(with presentation: OnboardingPresentation) {
        contentImageView.image = presentation.contentImageName.image
        borderImageView.image = presentation.borderImageName.image
        textLabel.font = .regularSubheading
        textLabel.textColor = .armonyWhite
        textLabel.text = presentation.text
    }
}
