//
//  VisitedAccountMusicalProfileViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 11.12.22.
//

import Foundation

final class VisitedAccountMusicalProfileViewModel: ViewModel {
    
    var coordinator: VisitedAccountMusicalProfileCoordinator!
    private weak var view: VisitedAccountMusicalProfileViewDelegate?

    private let skillsPresentation: SkillsPresentation
    private let musicGenresPresentation: MusicGenresPresentation

    init(view: VisitedAccountMusicalProfileViewDelegate,
         skills skillsPresentation: SkillsPresentation,
         musicGenres musicGenresPresentation: MusicGenresPresentation) {
        self.view = view
        self.skillsPresentation = skillsPresentation
        self.musicGenresPresentation = musicGenresPresentation
        super.init()
    }
}

// MARK: - ViewModelLifeCycle
extension VisitedAccountMusicalProfileViewModel: ViewModelLifeCycle {

    func viewDidLoad() {
        view?.configureMusicGenresView(with: musicGenresPresentation)
        view?.configureSkillsView(with: skillsPresentation)

        if musicGenresPresentation.items.isEmpty && skillsPresentation.skills.isEmpty {
            view?.showEmptyStateView(with: .noContent)
        }
    }
}

// MARK: - EmptyStatePresentation
private extension EmptyStatePresentation {
    static var noContent: EmptyStatePresentation = {
        let title = String("VisitedAccount.MusicalProfile.EmptyState.Title", table: .account)

        let presentation = EmptyStatePresentation(title: title)
        return presentation
    }()
}
