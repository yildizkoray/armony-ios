//
//  MusicGenresView.swift
//  Armony
//
//  Created by Koray Yıldız on 24.01.2022.
//

import UIKit

final class MusicGenresView: UIView, NibLoadable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var separatorLine: GradientView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var flowLayout: LeftAlignedFlowLayout!

    private var presentation: MusicGenresPresentation = .empty {
        didSet {
            self.collectionView.reloadData()
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
        configureCollectionView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        configureCollectionView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.collectionViewHeightConstraint.constant = presentation.shouldAdjustCellHeight ? presentation.cellHeight : self.collectionView.contentSize.height
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        flowLayout.scrollDirection = presentation.shouldAdjustCellHeight ? .horizontal : .vertical
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCells(for: [MusicGenreCell.self])
    }

    func configure(with presentation: MusicGenresPresentation) {
        self.presentation = presentation
        titleLabel.attributedText = presentation.title
        separatorLine.configure(with: presentation.separatorPresentation)
    }
}

// MARK: - UICollectionViewDataSource
extension MusicGenresView: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentation.items.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MusicGenreCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = presentation.items[indexPath.row]
        let cellPresentation = MusicGenreCellPresentation(
            borderColor: presentation.cellBorderColor,
            borderWidth: 1.0,
            item: item
        )
        cell.configure(with: cellPresentation)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MusicGenresView: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: presentation.cellWidth(at: indexPath, containerHeight: collectionView.frame.size.height),
                      height: presentation.cellHeight)
    }
}
