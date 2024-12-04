//
//  AdvertsCollectionHeaderView.swift
//  Armony
//
//  Created by Koray Yıldız on 5.02.2024.
//

import UIKit

final class AdvertsCollectionHeaderView: UICollectionReusableView {

    private lazy var bannerSliderView: BannerSliderView = BannerSliderView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let edges = UIEdgeInsets(edges: .sixteen)
        addSubviewAndConstraintsToEdges(bannerSliderView, insets: edges)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(presentation: BannerSliderPresentation, delegate: BannerSliderViewDelegate?) {
        bannerSliderView.configure(presentation: presentation, delegate: delegate)
    }
}
