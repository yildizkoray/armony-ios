//
//  CardView.swift
//  Armony
//
//  Created by Koray Yildiz on 23.12.22.
//

import UIKit

public final class CardView: UIView, NibLoadable {

    @IBOutlet private weak var colorfulHeaderView: UIView!
    @IBOutlet private weak var infoContainerView: UIView!
    @IBOutlet private weak var userSummaryView: UserSummaryView!
    @IBOutlet private weak var skillsView: SkillsView!
    @IBOutlet private weak var genreView: MusicGenresView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
        configureUI()
    }

    fileprivate func configureUI() {
        infoContainerView.makeCornersRounded(radius: .medium, CALayer.topCorners)
        infoContainerView.setBackgroundColor(.darkBlue)
    }

    public func configure(presentation: CardPresentation) {
        colorfulHeaderView.backgroundColor = presentation.colorCode.colorFromHEX
        userSummaryView.configure(with: presentation.userSummaryPresentation)
        skillsView.configure(with: presentation.skillsPresentation)

        skillsView.isHidden = presentation.genrePresentation.isNotNil
        genreView.isHidden = presentation.genrePresentation.isNil
        if let present = presentation.genrePresentation {
            genreView.configure(with: present)
        }
    }

    func prepareForReuse() {
        userSummaryView.prepareForReuse()
    }
}
