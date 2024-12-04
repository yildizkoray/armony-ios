//
//  BannerSliderCell.swift
//  Armony
//
//  Created by Koray Yıldız on 1.02.2024.
//

import UIKit
import SnapKit

final class BannerSliderCell: UICollectionViewCell {

    private lazy var containerStackView: UIStackView = {
        let config = UIStackView.Configuration(
            spacing: .twelve,
            axis: .horizontal,
            layoutMargins: .init(edges: .eight),
            alligment: .center
        )
        let stackView = UIStackView(config: config)
        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeAllCornersRounded(radius: .low)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBody
        label.textColor = .armonyDarkBlue
        label.numberOfLines = 4
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.width.equalTo(108)
            make.height.equalTo(64)
        }

        containerStackView.addArrangedSubviews(imageView, titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with presentation: BannerSliderItemPresentation, roundedCorners: CACornerMask?) {
        imageView.setImage(source: .url(presentation.imageURL))
        titleLabel.text = presentation.title
        contentView.setBackgroundColor(presentation.backgroundColor)
        if let roundedCorners {
            contentView.makeCornersRounded(radius: .low, roundedCorners)
        }
    }
}
