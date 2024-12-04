//
//  AdvertCell.swift
//  Armony
//
//  Created by Koray Yıldız on 8.09.2021.
//

import UIKit

final class AdvertCell: UICollectionViewCell {

    @IBOutlet private weak var cardView: CardView!

    private var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)

        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.alpha = AppTheme.Alpha.medium.rawValue
        return visualEffectView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.makeAllCornersRounded(radius: .medium)

        visualEffectView.frame = cardView.bounds
        cardView.addSubview(visualEffectView)
        visualEffectView.isHidden = true

        contentView.subviews.forEach {
            $0.isUserInteractionEnabled = false
        }
    }

    func configure(with presentation: AdvertPresentation) {
        let cardPresentation = CardPresentation(
            id: presentation.id,
            colorCode: presentation.colorCode,
            isActive: presentation.isActive, 
            status: presentation.status,
//            titleAccessoryPresentation: presentation.titleAccessoryPresentation,
            userSummaryPresentation: presentation.userSummaryPresentation,
            skillsPresentation: presentation.skillsPresentation
        )

        cardView.configure(presentation: cardPresentation)
    }

    func configure(card: CardPresentation) {
        cardView.configure(presentation: card)
    }

    func configure(forUserAdvert card: CardPresentation) {
        cardView.configure(presentation: card)
        visualEffectView.isHidden = !(card.status == .autoInactive)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cardView.prepareForReuse()
    }
}
