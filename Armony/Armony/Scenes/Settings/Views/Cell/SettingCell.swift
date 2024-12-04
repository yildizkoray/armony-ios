//
//  SettingTableViewCell.swift
//  Armony
//
//  Created by Koray Yildiz on 28.05.22.
//

import UIKit

final class SettingCell: UITableViewCell {

    @IBOutlet private weak var separatorView: GradientView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var accessoryImageView: UIImageView!

    func configure(with presentation: SettingPresentation) {
        titleLabel.hidableText = presentation.title
        accessoryImageView.image = presentation.accessoryImageName.image
        separatorView.configure(with: .separator)

        // TODO: - Refactore here
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        titleLabel.font = .lightBody
        titleLabel.textColor = .armonyWhite
        selectionStyle = .none
    }
}
