//
//  VisitedAccountViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 11.12.22.
//

import Foundation

final class VisitedAccountViewModel: ViewModel {

    var coordinator: VisitedAccountCoordinator!
    private weak var view: VisitedAccountViewDelegate?

    private let userID: String

    private var response: UserDetail? = nil
    private var authenticator: AuthenticationService = .shared

    init(view: VisitedAccountViewDelegate, userID: String) {
        self.view = view
        self.userID = userID
        super.init()
    }

    private func fetchUserDetail() {
        service.execute(task: GetUserTask(id: userID), type: RestObjectResponse<UserDetail>.self) { [weak self] result in

            switch result {
            case .success(let response):
                self?.response = response.data

                let _ = self?.userID != self?.authenticator.userID
                let avatar = AvatarPresentation(kind: .custom(.init(size: .custom(72), radius: .medium)), source: .url(response.data.avatarURL))
                let userSummaryPresentation = UserSummaryPresentation(
                    avatarPresentation: avatar,
                    shouldShowDotsButton: false,
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
                    musicGenres: genres,
                    userID: self?.userID ?? .empty
                )

            case .failure(let error):
                AlertService.show(error: error, actions: [.cancel()])
            }
        }
    }

    private func resetViews() {
        view?.configureUserSummaryView(with: .empty())
        view?.setBioLabelText(.empty)
        view?.configurePager(skills: .empty, musicGenres: .empty, userID: .empty)
    }
}

// MARK: - ViewModelLifeCycle
extension VisitedAccountViewModel: ViewModelLifeCycle {
    func viewDidLoad() {
        view?.makeNavigationBarTransparent()
        resetViews()
        fetchUserDetail()

        MixPanelScreenViewEvent(
            parameters: [
                "screen": "Visited Account",
            ]
        ).send()
    }
}
