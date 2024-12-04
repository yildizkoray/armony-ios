//
//  SegmentedControl.swift
//  Armony
//
//  Created by Koray Yıldız on 08.10.22.
//

import UIKit

protocol SegmentedControlViewDelegate: AnyObject {
    func segmentedControlView(_ view: SegmentedControlView, didSelect index: Int)
}

final class SegmentedControlView: UIView, NibLoadable {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!

    private(set) var currentSelectedIndex: Int = .zero

    weak var delegate: SegmentedControlViewDelegate?

    private var presentation: SegmentedControlPresentation = .empty {
        didSet {
            collectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        configureCollectionView()
    }

    fileprivate func configureCollectionView() {
        collectionView.registerCells(for: [SegmentCell.self])
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false

        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = .zero
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
        configureCollectionView()
    }

    func configure(presentation: SegmentedControlPresentation) {
        self.presentation = presentation
        setSelectedItem(at: presentation.selectedIndex)
    }

    func select(segmentAt index: Int) {
        if index != currentSelectedIndex {
            deselectItem(at: currentSelectedIndex)
        }
        setSelectedItem(at: index)
        delegate?.segmentedControlView(self, didSelect: index)
    }

    private func setSelectedItem(at index: Int) {
        let selectedIndexPath = IndexPath(row: index, section: .zero)

        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: false)
            self.collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)

            if let cell = self.collectionView.cellForItem(at: selectedIndexPath) as? SegmentCell {
                cell.select(color: self.presentation.selectedColor)
            }
        }
    }

    private func deselectItem(at index: Int) {
        let oldSelectedIndexPath = IndexPath(row: index, section: .zero)

        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: oldSelectedIndexPath, at: .centeredHorizontally, animated: false)
            self.collectionView.deselectItem(at: oldSelectedIndexPath, animated: true)

            if let cell = self.collectionView.cellForItem(at: oldSelectedIndexPath) as? SegmentCell {
                cell.deselect()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SegmentedControlView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentation.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SegmentCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(
            title: presentation.items[indexPath.row],
            style: presentation.textAppearance
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SegmentedControlView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SegmentCell {
            currentSelectedIndex = indexPath.row
            cell.select(color: presentation.selectedColor)
            delegate?.segmentedControlView(self, didSelect: indexPath.row)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SegmentCell {
            cell.deselect()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SegmentedControlView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  collectionView.frame.width / CGFloat(presentation.items.count)
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
