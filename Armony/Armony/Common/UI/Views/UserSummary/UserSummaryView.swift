//
//  UserSummaryView.swift
//  Armony
//
//  Created by Koray Yıldız on 1.09.2021.
//

import UIKit

protocol UserSummaryViewDelegate: AnyObject {
    func didTapInfoDotsButton(_ userSummaryView: UserSummaryView)
}

final class UserSummaryView: UIView, NibLoadable {

    @IBOutlet private weak var avatarView: AvatarView!
    @IBOutlet private weak var cardTitleLabel: UILabel!
    @IBOutlet private weak var dateImageView: UIImageView!
    @IBOutlet private weak var cardDateLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var userTitleLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var locationImageView: UIImageView!
    @IBOutlet private(set) weak var infoDotButton: UIButton!

    var didTapAvatarView: Callback<UIImage?>? = nil
    var didTapNameLabel: VoidCallback? = nil

    weak var delegate: UserSummaryViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        addTapGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
        addTapGesture()

        infoDotButton.touchUpInsideAction = { [unowned self] _ in
            self.delegate?.didTapInfoDotsButton(self)
        }
    }

    private func addTapGesture() {
        avatarView.addTapGestureRecognizer(action: { [weak self] _ in
            self?.didTapAvatarView?(self?.avatarView.imageView.image)
        })

        nameLabel.addTapGestureRecognizer(action: { [weak self] _ in
            self?.didTapNameLabel?()
        })
    }

    func configure(with presentation: UserSummaryPresentation) {
        avatarView.configure(with: presentation.avatarPresentation)
        
        cardTitleLabel.hidableAttributedText = presentation.cardTitle
        cardDateLabel.hidableAttributedText = presentation.updateDate
        dateImageView.isHidden = cardDateLabel.isHidden

        let parentStackView = (dateImageView.superview as? UIStackView)
        let hasVisibleView = parentStackView?.subviews.first { $0.isHidden == false }
        parentStackView?.isHidden = hasVisibleView.isNil

        nameLabel.hidableAttributedText = presentation.name
        userTitleLabel.hidableAttributedText = presentation.title
        infoDotButton.isHidden = !presentation.shouldShowDotsButton
        locationLabel.hidableAttributedText = presentation.location
        locationImageView.isHidden = presentation.location.ifNil(.empty).string.isEmpty
    }

    func prepareForReuse() {
        avatarView.imageView.image = nil
    }
}
