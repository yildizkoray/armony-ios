//
//  ViewController.swift
//  Armony
//
//  Created by Koray Yıldız on 19.08.2021.
//

import UIKit

private struct Constant {
    static let heightForCell: CGFloat = 186
    static let heightForSectionHeader: CGFloat = 112
}

protocol AdvertsViewDelegate: AnyObject, ActivityIndicatorShowing, EmptyStateShowing, RefreshControlShowing {
    
    func configureCollectionView()
    func configureNavigationBar()
    func configureUI()
    func deleteItems(indexPaths: [IndexPath], completion: @escaping Callback<Bool>)
    func insertItems(indexPaths: [IndexPath], completion: @escaping Callback<Bool>)
    func reloadCollectionView()
    func setCollectionViewVisibility(isHidden: Bool, animated: Bool)
}

final class AdvertsViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .home
    
    @IBOutlet private weak var collectionView: UICollectionView!

    var viewModel: AdvertsViewModel!

    private lazy var messageCountUIHandler: MessageCountUIHandler = .shared
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        messageCountUIHandler.start(with: self)
        viewModel.viewDidLoad()

        viewModel.filtersDidUpdate = { [weak self] filters in
            let iconName = filters.isEmpty ? "filter-default-icon" : "filter-selected-icon"
            self?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: iconName.image,
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self?.filterButtonTapped))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
        trackScreenView()
    }

    @objc private func chatsButtonTapped() {
        viewModel.chatsRightButtonTapped()
    }

    @objc private func filterButtonTapped() {
        viewModel.coordinator.filter(delegate: self, selectedFilters: viewModel.filters)
    }
}

// MARK: - AdvertsViewDelegate
extension AdvertsViewController: AdvertsViewDelegate {
    var containerScrollView: UIScrollView {
        return collectionView
    }

    var containerEmptyStateView: UIView {
        return collectionView
    }

    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(horizontal: .zero, vertical: 10.0)
        collectionView.registerCells(for: [AdvertCell.self])

        collectionView.register(supplemetaries: [
            (viewClass: AdvertsCollectionHeaderView.self, kind: .header)
        ])
    }

    func configureNavigationBar() {
        navigationItem.titleView = UIImageView(image: .armonyTitleIcon)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .homeMessagesIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(chatsButtonTapped))

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .filterDefaultIcon,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(filterButtonTapped))
    }

    func deleteItems(indexPaths: [IndexPath], completion: @escaping Callback<Bool>) {
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: indexPaths)
        } completion: { result in
            completion(result)
        }
    }

    func insertItems(indexPaths: [IndexPath], completion: @escaping Callback<Bool>) {
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: indexPaths)
        } completion: { result in
            completion(result)
        }
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
extension AdvertsViewController: UICollectionViewDataSource {

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

    func collectionView(_ collectionView: UICollectionView, 
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let headerView: AdvertsCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                kind: .header,
                for: indexPath
            )
            headerView.configure(presentation: viewModel.sliderPresentation, delegate: self)
            return headerView
        }

        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDataSource
extension AdvertsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let advert = viewModel.card(at: indexPath)
        viewModel.coordinator.advert(with: advert.id, colorCode: advert.colorCode) { [weak self] didBlockedUser in
            self?.viewModel.viewDidAppear()
            if didBlockedUser {
                self?.viewModel.fetchAdverts()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        viewModel.willDisplayItem(at: indexPath)
    }
}

// MARK: - UICollectionViewDataSource
extension AdvertsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: Constant.heightForCell)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = viewModel.sliderPresentation.isActive ? Constant.heightForSectionHeader : .zero
        return CGSize(width: collectionView.frame.width, height: height)
    }
}

// MARK: - FilterViewModelDelegate
extension AdvertsViewController: FilterViewModelDelegate {
    func applyButtonTapped(filters: FilterViewModel.Filters) {
        viewModel.filter(by: filters)
    }
}

// MARK: - BannerSliderViewDelegate
extension AdvertsViewController: BannerSliderViewDelegate {
    func bannerSliderView(_ view: BannerSliderView, didSelectItemAt index: Int) {
        let banner = viewModel.sliderPresentation.banners[index]
        let adjustToken = viewModel.sliderPresentation.adjustEvents[index]

        // Events
        BannerSliderAdjustEvent(token: adjustToken).send()
        let firebaseEvent = viewModel.sliderPresentation.firebaseEvents[index]
        firebaseEvent.send()

        viewModel.coordinator.open(deeplink: banner.deeplink)
    }
}
