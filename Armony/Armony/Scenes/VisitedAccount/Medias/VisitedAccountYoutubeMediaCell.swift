//
//  VisitedAccountYoutubeMediaCell.swift
//  Armony
//
//  Created by Koray Yıldız on 18.10.2023.
//

import UIKit
import YouTubeiOSPlayerHelper
import SnapKit

final class VisitedAccountYoutubeMediaCell: UITableViewCell {

    private lazy var youtubePlayer = YTPlayerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        youtubePlayer.backgroundColor = .red
        contentView.addSubview(youtubePlayer)

        youtubePlayer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with id: String) {
        youtubePlayer.load(withVideoId: id)
    }
}
