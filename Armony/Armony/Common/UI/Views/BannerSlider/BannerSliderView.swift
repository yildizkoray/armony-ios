//
//  BannerSliderView.swift
//  Armony
//
//  Created by Koray Yıldız on 1.02.2024.
//

import UIKit

protocol BannerSliderViewDelegate: AnyObject {
    func bannerSliderView(_ view: BannerSliderView, didSelectItemAt index: Int)
}

final class BannerSliderView: UIView {

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumLineSpacing = .zero
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var sliderCounterContainerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.makeAllCornersRounded(radius: .low)
        view.backgroundColor = .armonyDarkBlue
        return view
    }()

    private lazy var sliderCounterLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .regularBody
        label.textColor = .armonyWhite
        return label
    }()

    weak var delegate: BannerSliderViewDelegate?

    private var presentation: BannerSliderPresentation = .empty {
        didSet {
            collectionView.reloadData()
        }
    }

    private var currentIndex: Int = .zero {
        didSet {
            sliderCounterLabel.text = "\(currentIndex + 1)/\(presentation.banners.count)"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private func configureUI() {
        configureCollectionView()
        configureSliderCounterView()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = convert(collectionView.center, to: collectionView)
        if let index = collectionView.indexPathForItem(at: center) {
            currentIndex = index.item
        }
    }

    private func configureCollectionView() {
        addSubviewAndConstraintsToEdges(collectionView)
        collectionView.registerCells(classes: [BannerSliderCell.self])
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.makeAllCornersRounded(radius: .low)
        collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func configureSliderCounterView() {
        addSubview(sliderCounterContainerView)
        NSLayoutConstraint.activate([
            sliderCounterContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            sliderCounterContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])

        let insets = UIEdgeInsets.init(horizontal: 5, vertical: 2)
        sliderCounterContainerView.addSubviewAndConstraintsToEdges(
            sliderCounterLabel,
            insets: insets
        )
    }

    func configure(presentation: BannerSliderPresentation, delegate: BannerSliderViewDelegate?) {
        self.presentation = presentation
        self.delegate = delegate
        sliderCounterLabel.text = "1/\(presentation.banners.count)"
    }

    private func cellRoundedCorners(of collectionView: UICollectionView, at indexPath: IndexPath) -> CACornerMask? {
        if indexPath.row.isZero {
            return CALayer.leftCorners
        }
        if collectionView.isLastItem(indexPath: indexPath) {
            return CALayer.rightCorners
        }
        return nil
    }
}

// MARK: - UICollectionViewDataSource
extension BannerSliderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentation.banners.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BannerSliderCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = presentation.banners[indexPath.row]
        let roundedCorners = cellRoundedCorners(of: collectionView, at: indexPath)
        cell.configure(with: item, roundedCorners: roundedCorners)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BannerSliderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UICollectionViewDelegate
extension BannerSliderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.bannerSliderView(self, didSelectItemAt: indexPath.row)
    }
}
