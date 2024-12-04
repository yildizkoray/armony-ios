//
//  LiveChatNavigationTitleView.swift
//  Armony
//
//  Created by Koray Yıldız on 22.11.22.
//

import UIKit

final class LiveChatNavigationTitleView: UIView {

    private var containerStackView: UIStackView = {
        let config = UIStackView.Configuration(spacing: .eight, alligment: .center)
        var stack = UIStackView(config: config)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var avatarView: AvatarView = {
        let avatar = AvatarView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .semiboldHeading
        label.textColor = .armonyWhite
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviewAndConstraintsToEdges(containerStackView)
        containerStackView.addArrangedSubviews(avatarView, nameLabel)
    }

    func configure(presentation: LiveChatNavigationTitlePresentation) {
        avatarView.configure(with: .init(kind: .circled(.init(size: .custom(40))), source: .url(presentation.avatarURL)))
        nameLabel.text = presentation.name
    }
}
