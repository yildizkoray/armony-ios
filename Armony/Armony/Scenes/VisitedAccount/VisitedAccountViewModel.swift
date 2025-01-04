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
        Task {
            do {
                let response = try await service.execute(
                    task: GetUserTask(id: userID),
                    type: RestObjectResponse<UserDetail>.self
                )
                
                self.response = response.data
                
                await MainActor.run {
                    prepareUserSummary(response.data)
                    view?.setBioLabelText(response.data.bio)
                    prepareSkillsAndGenres(response.data)
                }
            }
            catch {
                error.showAlert()
            }
        }
    }
    
    private func prepareUserSummary(_ data: UserDetail) {
        let avatar = AvatarPresentation(
            kind: .custom(.init(size: .custom(72), radius: .medium)),
            source: .url(data.avatarURL)
        )
        let userSummary = UserSummaryPresentation(
            avatarPresentation: avatar,
            shouldShowDotsButton: false,
            name: data.name.attributed(color: .white, font: .regularHeading),
            title: data.title?.title.attributed(color: .white, font: .lightBody),
            location: data.location?.title.attributed(color: .white, font: .regularBody),
            cardTitle: .empty,
            updateDate: nil
        )
        
        view?.configureUserSummaryView(with: userSummary)
    }
    
    private func prepareSkillsAndGenres(_ data: UserDetail) {
        let skils = SkillsPresentation(
            type: .profile(imageViewContainerBackgroundColor: .armonyBlue),
            separatorPresentation: .separator,
            skillTitleStyle: .init(color: .white, font: .lightBody),
            skills: data.skills
        )
        let genreItemTitleStyle = TextAppearancePresentation(color: .white, font: .lightBody)
        let genreItems: [MusicGenreItemPresentation] = data.genres.lazy.map {
            MusicGenreItemPresentation(genre: $0, titleStyle: genreItemTitleStyle)
        }
        let genres = MusicGenresPresentation(cellBorderColor: .armonyBlue, items: genreItems)
        view?.configurePager(
            skills: skils,
            musicGenres: genres,
            userID: userID
        )
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
