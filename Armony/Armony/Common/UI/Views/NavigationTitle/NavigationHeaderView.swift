//
//  NavigationTitleView.swift
//  Armony
//
//  Created by Koray Yıldız on 16.01.2022.
//

import UIKit

public final class NavigationHeaderView: UIView, NibLoadable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var containerStackView: UIStackView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
    }

    public func configure(with presentation: NavigationHeaderPresentation) {
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = presentation.insets
        subtitleLabel.hidableAttributedText = presentation.subtitle
        titleLabel.attributedText = presentation.title
    }
}
