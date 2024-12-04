//
//  VisitedAccountViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 11.12.22.
//

import UIKit

protocol VisitedAccountViewDelegate: AnyObject, NavigationBarCustomizing, NavigationBarActivityIndicatorShowing {
    func configurePager(skills: SkillsPresentation, musicGenres: MusicGenresPresentation, userID: String)
    func configureUserSummaryView(with presentation: UserSummaryPresentation)
    func setBioLabelText(_ bio: String?)
}

final class VisitedAccountViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .visitedAccount

    @IBOutlet var gradientView: GradientView!
    @IBOutlet var userSummaryView: UserSummaryView!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var segmentedControl: SegmentedControlView!

    private weak var pager: PageViewController!

    private lazy var segmentedControlItems = ["Müzikal Profil", "İlanlar", "Performanslar", ] // TODO: - Localizable
    private lazy var segmentedControlPresentation = SegmentedControlPresentation(items: segmentedControlItems)

    var viewModel: VisitedAccountViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        viewModel.viewDidLoad()

        userSummaryView.didTapAvatarView = { [weak self] image in
            self?.viewModel.coordinator.avatar(with: .static(image))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeNavigationBarTransparent()
    }

    private func prepareUI() {
        let gradientPresentation = GradientPresentation(orientation: .vertical, color: .profile)
        gradientView.configure(with: gradientPresentation)

        segmentedControl.delegate = self
        segmentedControl.configure(presentation: segmentedControlPresentation)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pager" {
            pager = (segue.destination as! PageViewController)
        }
    }
}

// MARK: - AccountViewDelegate
extension VisitedAccountViewController: VisitedAccountViewDelegate {
    func configurePager(skills: SkillsPresentation, musicGenres: MusicGenresPresentation, userID: String) {
        let advertsViewController = advertsViewController(userID: userID)
        let accountSubdetailViewController = accountSubdetailViewController(
            skills: skills,
            musicGenres: musicGenres
        )
        let mediasView = mediasViewController(userID: userID)
        pager.setViewControllers([accountSubdetailViewController, advertsViewController, mediasView])
    }

    private func mediasViewController(userID: String) -> UIViewController {
        let mediasViewController = VisitedAccountMediasViewController.controller()
        let mediasViewModel = VisitedAccountMediasViewModel(userID: userID)
        let mediasCoordinator = VisitedAccountMediasCoordinator(navigator: navigationController)

        mediasViewController.viewModel = mediasViewModel
        mediasViewModel.coordinator = mediasCoordinator
        return mediasViewController
    }

    private func advertsViewController(userID: String) -> UIViewController {
        let advertsViewController = VisitedAccountAdvertsViewController.controller()
        let advertsViewModel = VisitedAccountAdvertsViewModel(view: advertsViewController, userID: userID)
        let advertsCoordinator = VisitedAccountAdvertsCoordinator(navigator: navigationController)

        advertsViewController.viewModel = advertsViewModel
        advertsViewModel.coordinator = advertsCoordinator
        return advertsViewController
    }

    private func accountSubdetailViewController(skills: SkillsPresentation,
                                                musicGenres: MusicGenresPresentation) -> UIViewController {
        let accountSubdetailView = VisitedAccountMusicalProfileViewController.controller()
        let accountSubdetailViewModel = VisitedAccountMusicalProfileViewModel(view: accountSubdetailView,
                                                                              skills: skills,
                                                                              musicGenres: musicGenres)
        accountSubdetailViewModel.coordinator = VisitedAccountMusicalProfileCoordinator()
        accountSubdetailView.viewModel = accountSubdetailViewModel
        return accountSubdetailView
    }


    func configureUserSummaryView(with presentation: UserSummaryPresentation) {
        userSummaryView.configure(with: presentation)
    }

    func setBioLabelText(_ bio: String?) {
        bioLabel.hidableText = bio
    }
}

// MARK: - SegmentedControlViewDelegate
extension VisitedAccountViewController: SegmentedControlViewDelegate {
    func segmentedControlView(_ view: SegmentedControlView, didSelect index: Int) {
        pager.move(at: index)
    }
}
