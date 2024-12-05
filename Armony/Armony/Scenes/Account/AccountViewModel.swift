//
//  AccountViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 18.04.22.
//

import Foundation

final class AccountViewModel: ViewModel {
    
    var coordinator: AccountCoordinator!
    private weak var view: AccountViewDelegate?
    private(set) var authenticator: AuthenticationService

    var currentSelectedSegmentIndex: Int = .zero

    private var accountDetailDidUpdateNotificationToken: NotificationToken? = nil

    private(set) var response: UserDetail? = nil
    var shouldFetchUserDetail = false
    var isViewDidLoad = false

    var profileViewModelDelegate: AccountMusicalProfileViewModelDelegate? {
        return self
    }

    init(view: AccountViewDelegate,
         authenticator: AuthenticationService = .shared,
         service: RestService = RestService(backend: .factory())) {
        self.view = view
        self.authenticator = authenticator
        super.init(service: service)
    }

    func showProfile() {
        if let response = response, authenticator.isAuthenticated {
            let profilePresentation = ProfilePresentation(
                bio: response.bio,
                avatarURLString: response.avatarURL?.absoluteString,
                title: response.title,
                skills: response.skills,
                musicGenres: response.genres,
                location: response.location
            )

            coordinator.profile(presentation: profilePresentation, delegate: self)
        }
    }

    private func fetchUserDetail() {
        service.execute(task: GetUserTask(id: authenticator.userID), type: RestObjectResponse<UserDetail>.self) { [weak self] result in

            self?.stopActivityIndicatorViews()

            switch result {
            case .success(let response):
                self?.response = response.data

                let avatar = AvatarPresentation(
                    kind: .custom(.init(size: .medium, radius: .medium)), 
                    source: .url(response.data.avatarURL)
                )
                let userSummaryPresentation = UserSummaryPresentation(
                    avatarPresentation: avatar,
                    name: response.data.name.attributed(color: .white, font: .regularHeading),
                    title: response.data.title?.title.attributed(color: .white, font: .lightBody),
                    location: response.data.location?.title.attributed(color: .white, font: .regularBody), 
                    cardTitle: .empty, 
                    updateDate: nil
                )

                self?.view?.configureUserSummaryView(with: userSummaryPresentation)
                self?.view?.setBioLabelText(response.data.bio)

                let skils = SkillsPresentation(
                    type: .profile(imageViewContainerBackgroundColor: .armonyBlue),
                    separatorPresentation: .separator,
                    skillTitleStyle: .init(color: .white, font: .lightBody),
                    skills: response.data.skills
                )
                let genreItemTitleStyle = TextAppearancePresentation(color: .white, font: .lightBody)
                let genreItems: [MusicGenreItemPresentation] = response.data.genres.lazy.map {
                    MusicGenreItemPresentation(genre: $0, titleStyle: genreItemTitleStyle)
                }
                let genres = MusicGenresPresentation(cellBorderColor: .armonyBlue, items: genreItems)
                self?.view?.configurePager(
                    skills: skils,
                    musicGenres: genres
                )

                self?.view?.selectSegment(at: self?.currentSelectedSegmentIndex ?? .zero)

            case .failure(let error):
                AlertService.show(message: error.description, actions: [.cancel()])
            }
        }
    }

    func resetViews() {
        currentSelectedSegmentIndex = .zero
        view?.configureUserSummaryView(with: .empty())
        view?.setBioLabelText(.empty)
        view?.configurePager(skills: .empty, musicGenres: .empty)
    }

    private func startActivityIndicatorViews() {
        view?.startRightBarButtonItemActivityIndicatorView()
        view?.startEditButtonActivityIndicatorView()
        view?.startAccountSubdetailEmptyStateButtonActivityIndicatorView()
    }

    private func stopActivityIndicatorViews() {
        view?.stopRightBarButtonItemActivityIndicatorView()
        view?.stopEditButtonActivityIndicatorView()
        view?.stopAccountSubdetailEmptyStateButtonActivityIndicatorView()
    }
}

// MARK: - ViewModelLifeCycle
extension AccountViewModel: ViewModelLifeCycle {
    func viewDidLoad() {
        view?.makeNavigationBarTransparent()

        if authenticator.isAuthenticated {
            startActivityIndicatorViews()
            fetchUserDetail()
        }
    }

    func viewWillAppear() {
        if authenticator.isAuthenticated {
            if shouldFetchUserDetail {
                startActivityIndicatorViews()
                fetchUserDetail()
                shouldFetchUserDetail = false
            }
        }
        else {
            resetViews()
        }
    }
}

// MARK: - ProfileViewModelDelegate
extension AccountViewModel: ProfileViewModelDelegate {
    func didUpdateUserProfile() {
        shouldFetchUserDetail = true
    }
}

// MARK: - AccountMusicalProfileViewModelDelegate
extension AccountViewModel: AccountMusicalProfileViewModelDelegate {
    func emptyStateButtonTapped() {
        showProfile()
    }
}
