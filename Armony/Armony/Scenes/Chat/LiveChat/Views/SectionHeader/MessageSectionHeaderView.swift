//
//  MessageSectionHeaderView.swift
//  Armony
//
//  Created by Koray Yıldız on 22.11.22.
//

import UIKit
import MessageKit

final class MessageSectionHeaderView: MessageReusableView {

    private lazy var cardView: CardView = CardView()
    private lazy var cardDidTap: VoidCallback? = nil

    private var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)

        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.alpha = AppTheme.Alpha.low.rawValue
        return visualEffectView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configureUI()
    }

    fileprivate func configureUI() {
        cardView.backgroundColor = .armonyDarkBlue
        addSubviewAndConstraintsToEdges(cardView, insets: UIEdgeInsets(edges: .sixteen))
        cardView.makeAllCornersRounded(radius: .medium)

        visualEffectView.frame = cardView.bounds
        cardView.addSubview(visualEffectView)
        visualEffectView.isHidden = true

        cardView.addTapGestureRecognizer { [weak self] _ in
            self?.cardDidTap?()
        }
    }

    func configure(cardPresentation: CardPresentation, didTap: VoidCallback?) {
        cardView.configure(presentation: cardPresentation)
        cardView.isUserInteractionEnabled = cardPresentation.isActive
        visualEffectView.isHidden = cardPresentation.isActive
        self.cardDidTap = didTap
    }
}
