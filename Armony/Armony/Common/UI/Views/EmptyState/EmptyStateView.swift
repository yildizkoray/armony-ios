//
//  EmptyStateView.swift
//  Armony
//
//  Created by Koray Yildiz on 12.05.22.
//

import Foundation
import UIKit

final class EmptyStateView: UIView, NibLoadable {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private(set) weak var actionButton: UIButton!

    private var action: Callback<UIButton>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
    }

    func configure(with presentation: EmptyStatePresentation, action actionButtonDidTap: Callback<UIButton>? = nil) {
        imageView.image = presentation.image
        imageView.isHidden = presentation.image.isNil

        titleLabel.hidableAttributedText = presentation.title
        subtitleLabel.hidableAttributedText = presentation.subtitle

        actionButton.setHidableAttributedTitle(presentation.buttonTitle, state: .normal)
        actionButton.backgroundColor = .armonyPurple
        actionButton.makeAllCornersRounded(radius: .medium)
        self.action = actionButtonDidTap
    }

    @IBAction private func actionButtonDidTap() {
        action?(actionButton)
    }
}
