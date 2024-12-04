//
//  YoutubeMediaCell.swift
//  Armony
//
//  Created by Koray Yıldız on 15.10.2023.
//

import UIKit
import YouTubeiOSPlayerHelper
import SnapKit

final class YoutubeMediaCell: UITableViewCell {

    private lazy var containerStackView: UIStackView = {
        let config = UIStackView.Configuration(
            spacing: .sixteen,
            axis: .vertical,
            layoutMargins: .init(edges: .sixteen)
        )
        let stackview = UIStackView(
            arrangedSubviews: [youtubePlayer, deleteButtonContainerStackView],
            config: config
        )
        return stackview
    }()

    private lazy var deleteButtonContainerStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [UIView(), deleteButton])
        return stackview
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonConfiguration = UIButton.Config(title: "Videoyu sil",
                                                  titleColor: .blue,
                                                  titleFont: .lightBody,
                                                  backgroundColor: .clear)
        button.configure(with: buttonConfiguration)
        return button
    }()

    private lazy var youtubePlayer = YTPlayerView()

    private var deleteButtonTapped: VoidCallback? = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        youtubePlayer.backgroundColor = .red
        contentView.addSubview(containerStackView)

        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        deleteButton.setContentHuggingPriority(.required, for: .vertical)
        deleteButton.setContentHuggingPriority(.required, for: .horizontal)
        deleteButton.setContentCompressionResistancePriority(.required, for: .vertical)

        deleteButton.touchUpInsideAction = { [weak self] _ in
            self?.deleteButtonTapped?()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with id: String, deleteButtonTapped: @escaping VoidCallback) {
        self.deleteButtonTapped = deleteButtonTapped
        youtubePlayer.load(withVideoId: id)
    }
}
