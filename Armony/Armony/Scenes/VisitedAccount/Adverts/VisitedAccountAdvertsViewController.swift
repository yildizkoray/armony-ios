//
//  VisitedAccountAdvertsViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 11.12.22.
//

import UIKit

private struct Constant {
    static let heightForCell: CGFloat = 191
}

protocol VisitedAccountAdvertsViewDelegate: AnyObject, ActivityIndicatorShowing, EmptyStateShowing {

    func configureCollectionView()
    func configureUI()
    func reloadCollectionView()
    func setCollectionViewVisibility(isHidden: Bool, animated: Bool)
}

final class VisitedAccountAdvertsViewController: UIViewController, ViewController {

    var viewModel: VisitedAccountAdvertsViewModel!

    @IBOutlet private weak var collectionView: UICollectionView!

    static var storyboardName: UIStoryboard.Name = .visitedAccount

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
}

// MARK: - UserAdvertsViewDelegate
extension VisitedAccountAdvertsViewController: VisitedAccountAdvertsViewDelegate {
    var containerEmptyStateView: UIView {
        collectionView
    }

    func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(horizontal: .zero, vertical: 10.0)
        collectionView.registerCells(for: [AdvertCell.self])
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }

    func configureUI() {
        view.backgroundColor = .armonyBlack
    }

    func setCollectionViewVisibility(isHidden: Bool, animated: Bool) {
        collectionView.setHidden(isHidden, animated: animated)
    }
}

// MARK: - UICollectionViewDataSource
extension VisitedAccountAdvertsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AdvertCell = collectionView.dequeueReusableCell(for: indexPath)
        let card = viewModel.card(at: indexPath)
        cell.configure(card: card)
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension VisitedAccountAdvertsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let advert = viewModel.card(at: indexPath)
        viewModel.coordinator.advert(with: advert.id, colorCode: advert.colorCode)
    }
}

// MARK: - UICollectionViewDataSource
extension VisitedAccountAdvertsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: Constant.heightForCell)
    }
}
