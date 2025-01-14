//
//  UserAdvertsViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 24.05.22.
//

import UIKit

private struct Constant {
    static let heightForCell: CGFloat = 191
}

protocol UserAdvertsViewDelegate: AnyObject, ActivityIndicatorShowing, EmptyStateShowing, RefreshControlShowing {

    func configureCollectionView()
    func configureNavigationBar()
    func configureUI()
    func deleteItems(indexPaths: [IndexPath])
    func reloadCollectionView()
    func setCollectionViewVisibility(isHidden: Bool, animated: Bool)
}

final class UserAdvertsViewController: UIViewController, ViewController {

    var viewModel: UserAdvertsViewModel!

    @IBOutlet private weak var collectionView: UICollectionView!

    static var storyboardName: UIStoryboard.Name = .account

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        view.backgroundColor = .armonyBlack
        collectionView.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
        trackScreenView()
    }
}

// MARK: - UserAdvertsViewDelegate
extension UserAdvertsViewController: UserAdvertsViewDelegate {
    var containerScrollView: UIScrollView {
        return collectionView
    }
    
    var containerEmptyStateView: UIView {
        return collectionView
    }

    func deleteItems(indexPaths: [IndexPath]) {
        collectionView.deleteItems(indexPaths) { }
    }

    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(horizontal: .zero, vertical: 10.0)
        collectionView.registerCells(for: [AdvertCell.self])
    }

    func configureNavigationBar() {
        navigationItem.titleView = UIImageView(image: .armonyTitleIcon)
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
extension UserAdvertsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AdvertCell = collectionView.dequeueReusableCell(for: indexPath)
        let card = viewModel.card(at: indexPath)
        cell.configure(forUserAdvert: card)
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension UserAdvertsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let advert = viewModel.card(at: indexPath)
        viewModel.coordinator.advert(with: advert.id, colorCode: advert.colorCode) { [weak self] isReactivatedAdvert in
            if isReactivatedAdvert {
                self?.viewModel.fetchAdverts()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension UserAdvertsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: Constant.heightForCell)
    }
}
