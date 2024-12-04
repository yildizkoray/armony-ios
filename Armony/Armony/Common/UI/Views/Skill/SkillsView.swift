//
//  SkillsView.swift
//  Armony
//
//  Created by Koray Yıldız on 8.10.2021.
//

import UIKit

public final class SkillsView: UIView, NibLoadable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var separatorLine: GradientView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var flowLayout: LeftAlignedFlowLayout!

    private var presentation: SkillsPresentation = .empty {
        didSet {
            collectionView.reloadData()
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

    public override func layoutSubviews() {
        super.layoutSubviews()

        collectionViewHeightConstraint.constant = presentation.collectionViewHeight(for: collectionView.contentSize)
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        flowLayout.scrollDirection = presentation.type.scrollDirection
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCells(for: [SkillCell.self])
    }

    func configure(with presentation: SkillsPresentation) {
        self.presentation = presentation
        titleLabel.attributedText = presentation.title
        flowLayout.minimumLineSpacing = presentation.type.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = presentation.type.minimumInteritemSpacing
        separatorLine.configure(with: presentation.separatorPresentation)
    }
}

// MARK: - UICollectionViewDataSource
extension SkillsView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentation.skills.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SkillCell = collectionView.dequeueReusableCell(for: indexPath)
        let skill = presentation.skills[indexPath.row]
        let cellPresentation = SkillCellPresentation(axis: presentation.type.axis,
                                                     spacing: presentation.type.spacing,
                                                     imageViewContainerViewWidth: presentation.type.imageViewContainerViewWidth,
                                                     inset: presentation.type.imageViewContainerViewInset,
                                                     imageContainerViewColor: presentation.type.imageViewContainerViewBackgroundColor,
                                                     imageContainerViewBorderColor: presentation.type.imageViewContainerViewBorderColor,
                                                     imageContainerViewBorderWidth: presentation.type.imageViewContainerViewBorderWidth,
                                                     skill: skill)
        cell.configure(with: cellPresentation)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SkillsView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: presentation.cellWidth(at: indexPath), height: presentation.type.cellHeight)
    }
}
