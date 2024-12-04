//
//  AccountMusicalProfileViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 23.04.22.
//

import Foundation

protocol AccountMusicalProfileViewModelDelegate: AnyObject {
    func emptyStateButtonTapped()
}

final class AccountMusicalProfileViewModel: ViewModel {
    var coordinator: AccountMusicalProfileCoordinator!
    private weak var view: AccountMusicalProfileViewDelegate?

    private weak var delegate: AccountMusicalProfileViewModelDelegate?
    private let skillsPresentation: SkillsPresentation
    private let musicGenresPresentation: MusicGenresPresentation

    init(view: AccountMusicalProfileViewDelegate,
         skills skillsPresentation: SkillsPresentation,
         musicGenres musicGenresPresentation: MusicGenresPresentation,
         delegate: AccountMusicalProfileViewModelDelegate?) {
        self.view = view
        self.skillsPresentation = skillsPresentation
        self.musicGenresPresentation = musicGenresPresentation
        self.delegate = delegate
        super.init()
    }
}

// MARK: - ViewModelLifeCycle
extension AccountMusicalProfileViewModel: ViewModelLifeCycle {

    func viewDidLoad() {
        view?.configureMusicGenresView(with: musicGenresPresentation)
        view?.configureSkillsView(with: skillsPresentation)
        view?.hideEmptyStateView(animated: false)

        if skillsPresentation.skills.isEmpty && musicGenresPresentation.items.isEmpty {
            view?.showEmptyStateView(with: .noContent) { [weak self] _ in
                self?.delegate?.emptyStateButtonTapped()
            }
        }
        else {
            view?.hideEmptyStateView(animated: true)
        }
    }
}

// MARK: - EmptyStatePresentation
private extension EmptyStatePresentation {
    static var noContent: EmptyStatePresentation = {
        let title = String(localized: "MusicalProfile.EmptyState.Title", table: "Account+Localizable").emptyStateTitleAttributed
        let buttonTitle = String(localized: "MusicalProfile.EmptyState.Button.Title", table: "Account+Localizable").emptyStateButtonAttributed
        let presentation = EmptyStatePresentation(title: title, buttonTitle: buttonTitle)
        return presentation
    }()
}
