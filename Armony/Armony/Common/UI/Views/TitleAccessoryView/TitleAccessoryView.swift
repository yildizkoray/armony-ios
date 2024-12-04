//
//  TitleAccessoryView.swift
//  Armony
//
//  Created by Koray Yildiz on 23.12.22.
//

import UIKit

final class TitleAccessoryView: UIView {

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, accessoryImageView])
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var accessoryImageView: UIImageView = {
        let accessoryImageView = UIImageView()
        accessoryImageView.contentMode = .scaleAspectFit
        accessoryImageView.setContentHuggingPriority(.required, for: .horizontal)
        return accessoryImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private func configureUI() {
        addSubviewAndConstraintsToEdges(containerStackView)
    }

    func configure(with presentation: TitleAccessoryPresentation) {
        titleLabel.hidableAttributedText = presentation.title
        accessoryImageView.setImage(source: presentation.accessoryImage)
    }
}
