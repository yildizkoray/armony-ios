//
//  ChatCell.swift
//  Armony
//
//  Created by Koray Yıldız on 16.11.22.
//

import UIKit

final class ChatCell: UITableViewCell {

    @IBOutlet private weak var avatarView: AvatarView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var separatorView: GradientView!
    @IBOutlet private weak var unreadDotIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(with presentation: ChatItemPresentation) {
        titleLabel.font = .regularSubheading
        titleLabel.textColor = .armonyWhite
        titleLabel.text = presentation.title

        subtitleLabel.font = .lightBody
        subtitleLabel.textColor = .armonyWhite
        subtitleLabel.text = presentation.previewMessage

        let avatarPresentation = AvatarPresentation(kind: .custom(.init(size: .custom(44), radius: .low)),
                                                    source: .url(presentation.avatarURL))
        avatarView.configure(with: avatarPresentation)
        separatorView.configure(with: .separator)
        unreadDotIcon.isHidden = presentation.isRead
    }

    func hideUnreadIcon() {
        unreadDotIcon.isHidden = true
    }
}
