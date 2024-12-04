//
//  SelectionCell.swift
//  Armony
//
//  Created by Koray Yildiz on 03.06.22.
//

import UIKit

final class SelectionCell: UITableViewCell {

    @IBOutlet private weak var checkboxImageView: UIImageView!
    @IBOutlet private weak var title: UILabel!

    func configure(with presentation: SelectionInput, imageName: String) {
        backgroundColor = .clear
        selectionStyle = .none

        title.font = .lightBody
        title.textColor = .armonyWhite
        title.text = presentation.title

        checkboxImageView.image = imageName.image
    }

    func updateSelectionStateImageView(imageName: String) {
        checkboxImageView.image = imageName.image
    }
}
