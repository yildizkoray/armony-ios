//
//  VisitedAccountMusicalProfileViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 11.12.22.
//

import UIKit

protocol VisitedAccountMusicalProfileViewDelegate: AnyObject, EmptyStateShowing {
    func configureMusicGenresView(with presentation: MusicGenresPresentation)
    func configureSkillsView(with presentation: SkillsPresentation)
}

final class VisitedAccountMusicalProfileViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .visitedAccount

    @IBOutlet private weak var musicGenresView: MusicGenresView!
    @IBOutlet private weak var skillsView: SkillsView!

    var viewModel: VisitedAccountMusicalProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
    }
}

// MARK: - AccountMusicalProfileViewDelegate
extension VisitedAccountMusicalProfileViewController: VisitedAccountMusicalProfileViewDelegate {
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
