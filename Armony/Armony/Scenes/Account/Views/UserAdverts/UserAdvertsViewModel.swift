//
//  UserAdvertsViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 24.05.22.
//

import Foundation

final class UserAdvertsViewModel: ViewModel {

    var coordinator: UserAdvertsCoordinator!
    private weak var view: UserAdvertsViewDelegate?
    private let authenticator: AuthenticationService

    private var advertDidRemoveNotificationToken: NotificationToken? = nil

    private let advertCreateNotificationService: PlaceAdvertNotificationService = .shared

    var presentation: AdvertsPresentation = .empty {
        didSet {
            toggleEmptyStateView()
        }
    }

    var numberOfItemsInSection: Int {
        return presentation.cards.count
    }

    init(view: UserAdvertsViewDelegate, authenticator: AuthenticationService = .shared) {
        self.view = view
        self.authenticator = authenticator
        super.init()
    }

    func card(at indexPath: IndexPath) -> CardPresentation {
        return presentation.cards[indexPath.row]
    }

    func toggleEmptyStateView() {
        if presentation.cards.isEmpty {
            view?.showEmptyStateView(with: .noContent) { [weak self] _ in
                self?.coordinator.selectTab(tab: .placeAdvert)
            }
        }
        else {
            view?.hideEmptyStateView(animated: true)
        }
    }

    func fetchAdverts() {
        Task {
            do {
                let response = try await service.execute(task: GetUserAdvertsTask(userID: authenticator.userID),
                                                         type: RestArrayResponse<Advert>.self)

                safeSync {
                    view?.stopActivityIndicatorView()
                    presentation = AdvertsPresentation(adverts: response.data)

                    view?.setCollectionViewVisibility(isHidden: false, animated: true)
                    view?.reloadCollectionView()
                    view?.endRefreshing()
                }
            }
            catch let error {
                await AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }

    @objc func refresh() {
        fetchAdverts()
    }

    fileprivate func addAdvertRemoveNotificationToken() {
        advertDidRemoveNotificationToken = NotificationCenter.default.observe(name: .advertDidRemove, using: { [unowned self] notification in
            self.handleDidRemoveAdvert(notification)
        })
    }

    fileprivate func handleDidRemoveAdvert(_ notification: Notification) {
        if let advertID: Int = notification[.advertID] {
            guard let indexOfDeletedAdvert = presentation.cards.firstIndex(where: { $0.id == advertID }) else { return }
            self.presentation.cards.remove(at: indexOfDeletedAdvert)
            let indexPathOfDeletedAdvert = IndexPath(item: indexOfDeletedAdvert, section: .zero)
            view?.deleteItems(indexPaths: [indexPathOfDeletedAdvert])
        }
        NotificationCenter.default.removeObserver(advertDidRemoveNotificationToken as Any)
    }

    fileprivate func addDidPlaceAdvertNotificationToken() {
        advertCreateNotificationService.addNewAdvertPlaceHandler { [weak self] _ in
            self?.handleDidPlaceAdvert()
        }
    }

    fileprivate func handleDidPlaceAdvert() {
        view?.startActivityIndicatorView()
        view?.setCollectionViewVisibility(isHidden: true, animated: false)
        fetchAdverts()
    }
}

// MARK: - ViewModelLifeCycle
extension UserAdvertsViewModel: ViewModelLifeCycle {

    func viewDidLoad() {
        view?.startActivityIndicatorView()
        view?.configureCollectionView()
        view?.configureNavigationBar()
        view?.setCollectionViewVisibility(isHidden: true, animated: false)
        view?.addRefresher(self, color: .armonyBlue, selector: #selector(refresh))

        view?.configureUI()
        fetchAdverts()

        addDidPlaceAdvertNotificationToken()
        addAdvertRemoveNotificationToken()
    }
}

// MARK: - EmptyStatePresentation
private extension EmptyStatePresentation {
    static var noContent: EmptyStatePresentation = {
        let title = String(localized: "UserAds.EmptyState.Title", table: "Account+Localizable").emptyStateTitleAttributed
        let buttonTitle = String(localized: "UserAds.EmptyState.Button.Title", table: "Account+Localizable").emptyStateButtonAttributed

        let presentation = EmptyStatePresentation(title: title, buttonTitle: buttonTitle)
        return presentation
    }()
}
