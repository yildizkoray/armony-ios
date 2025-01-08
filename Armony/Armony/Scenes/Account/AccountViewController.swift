//
//  AccountViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 18.04.22.
//

import UIKit

protocol AccountViewDelegate: AnyObject, NavigationBarCustomizing, NavigationBarActivityIndicatorShowing {
    func configurePager(skills: SkillsPresentation, musicGenres: MusicGenresPresentation)
    func configureUserSummaryView(with presentation: UserSummaryPresentation)
    func setBioLabelText(_ bio: String?)
    func selectSegment(at index: Int)
    func startEditButtonActivityIndicatorView()
    func stopEditButtonActivityIndicatorView()

    func startAccountSubdetailEmptyStateButtonActivityIndicatorView()
    func stopAccountSubdetailEmptyStateButtonActivityIndicatorView()
}

final class AccountViewController: UIViewController, ViewController {
    static var storyboardName: UIStoryboard.Name = .account

    @IBOutlet private weak var gradientView: GradientView!
    @IBOutlet private weak var userSummaryView: UserSummaryView!
    @IBOutlet private weak var segmentedControl: SegmentedControlView!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var bioLabel: ExpandableLabel!

    private weak var pager: PageViewController!

    private lazy var segmentedControlItems = [
        String(localized: "Musical.Profile", table: "Account+Localizable"),
        String(localized: "My.Ads", table: "Account+Localizable"),
        String(localized: "My.Performances", table: "Account+Localizable")]
    private lazy var segmentedControlPresentation = SegmentedControlPresentation(items: segmentedControlItems)

    var viewModel: AccountViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentedControl()
        prepareUI()
        viewModel.viewDidLoad()

        addNotifications(
            viewModel.authenticator.addLogoutHandler({ [unowned self] _ in
                self.viewModel.shouldFetchUserDetail = true
                self.viewModel.resetViews()
            }),
            NotificationCenter.default.observe(name: .accountDetailDidUpdateInSettings, using: { [unowned self] _ in
                self.viewModel.shouldFetchUserDetail = true
            })
        )

        userSummaryView.didTapAvatarView = { [weak self] image in
            AvatarCoordinator().start(onto: self?.viewModel.coordinator.navigator, imageSource: .static(image))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenView()
    }

    @objc private func settingsButtonTapped() {
        viewModel.coordinator.settings()
    }

    @IBAction private func editButtonDidTap() {
        viewModel.showProfile()
    }

    private func prepareUI() {
        let homeButton = UIBarButtonItem(
            image: .accountSettingsIcon,
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
        navigationItem.rightBarButtonItem = homeButton

        let gradientPresentation = GradientPresentation(orientation: .vertical, color: .profile)
        gradientView.configure(with: gradientPresentation)

        bioLabel.font = .poppins(.light, size: 12.0)
        bioLabel.textColor = .armonyWhite

        bioLabel.collapsed = true
        bioLabel.numberOfLines = 3
        bioLabel.ellipsis = ". . .".attributed(.armonyWhite, font: .semiboldBody)
        let seeMore = String(localized: "More", table: "Common+Localizable")
        let seeLess = String(localized: "Less", table: "Common+Localizable")
        bioLabel.collapsedAttributedLink = seeMore.attributed(.armonyBlue, font: .regularBody)
        bioLabel.expandedAttributedLink = seeLess.attributed(.armonyBlue, font: .regularBody)

        editButton.setTitle(
            String(localized: "Edit", table: "Common+Localizable"), for: .normal
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pager" {
            pager = (segue.destination as! PageViewController)
        }
    }

    private func configureSegmentedControl() {
        segmentedControl.delegate = self
        segmentedControl.configure(presentation: segmentedControlPresentation)
    }
}

// MARK: - AccountViewDelegate
extension AccountViewController: AccountViewDelegate {
    func configurePager(skills: SkillsPresentation, musicGenres: MusicGenresPresentation) {
        let advertsViewController = advertsViewController()
        let accountSubdetailViewController = accountSubdetailViewController(
            skills: skills,
            musicGenres: musicGenres
        )
        let mediaViewController = UserMediasViewController.controller()
        let userViewModel = UserMediasViewModel()
        userViewModel.coordinator = UserMediasCoordinator()
        mediaViewController.viewModel = userViewModel
        pager.setViewControllers([accountSubdetailViewController, advertsViewController, mediaViewController], initialIndex: .zero)
    }

    func selectSegment(at index: Int) {
        segmentedControl.select(segmentAt: index)
    }

    private func advertsViewController() -> UIViewController {
        let advertsViewController = UserAdvertsViewController.controller()
        let advertsViewModel = UserAdvertsViewModel(view: advertsViewController)
        let advertsCoordinator = UserAdvertsCoordinator(navigator: navigationController!)

        advertsViewController.viewModel = advertsViewModel
        advertsViewModel.coordinator = advertsCoordinator
        return advertsViewController
    }

    private func accountSubdetailViewController(skills: SkillsPresentation,
                                                musicGenres: MusicGenresPresentation) -> UIViewController {
        let accountSubdetailView = AccountMusicalProfileViewController.controller()
        let accountSubdetailViewModel = AccountMusicalProfileViewModel(view: accountSubdetailView,
                                                                       skills: skills,
                                                                       musicGenres: musicGenres,
                                                                       delegate: viewModel.profileViewModelDelegate)
        accountSubdetailViewModel.coordinator = AccountMusicalProfileCoordinator()
        accountSubdetailView.viewModel = accountSubdetailViewModel
        return accountSubdetailView
    }


    func configureUserSummaryView(with presentation: UserSummaryPresentation) {
        userSummaryView.configure(with: presentation)
    }

    func setBioLabelText(_ bio: String?) {
        bioLabel.hidableText = bio
    }

    func startEditButtonActivityIndicatorView() {
        editButton.startActivityIndicatorView()
    }

    func stopEditButtonActivityIndicatorView() {
        editButton.stopActivityIndicatorView()
    }

    func startAccountSubdetailEmptyStateButtonActivityIndicatorView() {
        if let viewController = pager.viewControllers?.first as? AccountMusicalProfileCoordinator.Controller {
            viewController.startEmptyStateButtonActivityIndicatorView()
        }
    }

    func stopAccountSubdetailEmptyStateButtonActivityIndicatorView() {
        if let viewController = pager.viewControllers?.first as? AccountMusicalProfileCoordinator.Controller {
            viewController.stopEmptyStateButtonActivityIndicatorView()
        }
    }
}

// MARK: - SegmentedControlViewDelegate
extension AccountViewController: SegmentedControlViewDelegate {
    func segmentedControlView(_ view: SegmentedControlView, didSelect index: Int) {
        viewModel.currentSelectedSegmentIndex = index
        pager.move(at: index)
    }
}
