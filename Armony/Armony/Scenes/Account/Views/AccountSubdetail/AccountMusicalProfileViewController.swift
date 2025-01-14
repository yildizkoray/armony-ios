//
//  AccountMusicalProfileViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 22.04.22.
//

import UIKit

protocol AccountMusicalProfileViewDelegate: AnyObject, EmptyStateShowing {
    func configureMusicGenresView(with presentation: MusicGenresPresentation)
    func configureSkillsView(with presentation: SkillsPresentation)
}

final class AccountMusicalProfileViewController: UIViewController, ViewController {
    static var storyboardName: UIStoryboard.Name = .account

    @IBOutlet private weak var musicGenresView: MusicGenresView!
    @IBOutlet private weak var skillsView: SkillsView!

    var viewModel: AccountMusicalProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
    }

    func startEmptyStateButtonActivityIndicatorView() {
        emptyStateView.actionButton.activityIndicatorView.color = .gray
        emptyStateView.actionButton.startActivityIndicatorView()
    }

    func stopEmptyStateButtonActivityIndicatorView() {
        emptyStateView.actionButton.startActivityIndicatorView()
    }
}

// MARK: - AccountMusicalProfileViewDelegate
extension AccountMusicalProfileViewController: AccountMusicalProfileViewDelegate {
    var containerEmptyStateView: UIView {
        view
    }

    func configureMusicGenresView(with presentation: MusicGenresPresentation) {
        musicGenresView.configure(with: presentation)
        musicGenresView.isHidden = presentation.items.isEmpty // Don't be lazy move this logic into ViewModel
    }

    func configureSkillsView(with presentation: SkillsPresentation) {
        skillsView.configure(with: presentation)
        skillsView.isHidden = presentation.skills.isEmpty // Don't be lazy move this logic into ViewModel
    }
}
