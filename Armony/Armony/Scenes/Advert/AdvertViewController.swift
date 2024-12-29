//
//  AdvertViewController.swift
//  Armony
//
//  Created by Koray Yıldız on 23.11.2021.
//

import SwiftUI
import UIKit
import SafariServices

protocol AdvertViewDelegate: AnyObject, ActivityIndicatorShowing, NavigationBarCustomizing {
    func configureUserSummaryView(with presentation: UserSummaryPresentation)
    func configureSkillsView(with presentation: SkillsPresentation)
    func configureGenresView(with presentation: MusicGenresPresentation)
    func configureInstructionTypesView(with presentation: MusicGenresPresentation)

    func setDescriptionLabel(description: String)

    func setRemoveAdvertsButtonVisibility(isHidden: Bool)
    func setApplyButtonButtonVisibility(isHidden: Bool)

    func setContentStackViewVisibility(isHidden: Bool, animated: Bool)

    func startSendMessageButtonActivityIndicatorView()
    func stopSendMessageButtonActivityIndicatorView()

    func startDeleteButtonActivityIndicatorView()
    func stopDeleteButtonActivityIndicatorView()

    func startUserSummaryViewDotsButtonActivityIndicatorView()
    func stopUserSummaryViewDotsButtonActivityIndicatorView()

    func startActivateAdvertButtonActivityIndicatorView()
    func stopActivateAdvertButtonActivityIndicatorView()
}

final class AdvertViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .home

    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollableContentStackView: UIStackView!

    @IBOutlet private weak var gradientView: GradientView!
    @IBOutlet private weak var userSummaryView: UserSummaryView! {
        didSet {
            userSummaryView.delegate = self
        }
    }

    @IBOutlet private weak var descriptionLabel: ExpandableLabel!

    @IBOutlet private weak var skillsView: SkillsView!
    @IBOutlet private weak var genresView: MusicGenresView!

    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var sendMessageButton: UIButton!
    @IBOutlet private weak var activateAdvertButton: UIButton!
    @IBOutlet private weak var removeAdvertsButton: UIButton!

    private lazy var infoView: UIView = {
        let infoSwiftUIViewModel = InfoViewModel(
            iconName: "info-icon",
            text: String("Advert.Expire.Warning", table: .home)
        )
        let infoSwiftUIView = InfoView(viewModel: infoSwiftUIViewModel)
        let infoViewController = UIHostingController(rootView: infoSwiftUIView)
        let infoView = infoViewController.view!
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.backgroundColor = .clear
        return infoView
    }()

    private lazy var instructionTypesView = MusicGenresView()

    var viewModel: AdvertViewModel!

    @IBAction private func applyButtonTapped() {
        viewModel.sendMessageButtonTapped()
    }

    @IBAction private func activateAdvertButtonTapped() {
        viewModel.activateAdvertButtonTapped()
    }

    @IBAction private func removeButtonDidTap() {
        viewModel.removeAdvertsButtonDidTap()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.viewDidLoad()

        userSummaryView.didTapNameLabel = { [weak self] in
            self?.viewModel.nameDidTap()
        }

        userSummaryView.didTapAvatarView = { [weak self] _ in
            self?.viewModel.nameDidTap()
        }

        scrollableContentStackView.addArrangedSubview(instructionTypesView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.dismissCompletion?(false)
    }

    func configureUI() {
        view.backgroundColor = .armonyDarkBlue
        sendMessageButton.makeAllCornersRounded(radius: .medium)
        sendMessageButton.makeBordered(width: .default, color: .blue)
        sendMessageButton.setBackgroundColor(.darkBlue)

        removeAdvertsButton.makeAllCornersRounded(radius: .medium)
        activateAdvertButton.makeAllCornersRounded(radius: .medium)
        activateAdvertButton.makeBordered(width: .default, color: .blue)

        removeAdvertsButton.titleLabel?.font = .semiboldSubheading
        removeAdvertsButton.setTitleColor(.armonyWhite, for: .normal)
        removeAdvertsButton.setTitle(String("Advert.DeleteAd", table: .home), for: .normal)
        removeAdvertsButton.backgroundColor = .clear

        activateAdvertButton.titleLabel?.font = .semiboldHeading
        activateAdvertButton.setTitleColor(.armonyWhite, for: .normal)
        activateAdvertButton.setTitle(
            String("Advert.RepostAd", table: .home), for: .normal
        )
        activateAdvertButton.backgroundColor = .clear

        sendMessageButton.setTitle(
            String("Advert.SendMessage", table: .home), for: .normal
        )
        sendMessageButton.titleLabel?.font = .semiboldHeading
        sendMessageButton.setTitleColor(.armonyWhite, for: .normal)

        descriptionLabel.font = .lightBody
        descriptionLabel.textColor = .armonyWhite

        descriptionLabel.collapsed = true
        descriptionLabel.ellipsis = ". . .".attributed(.armonyWhite, font: .semiboldBody)

        let more = String("More", table: .common)
        let less = String("Less", table: .common)
        descriptionLabel.collapsedAttributedLink = more.attributed(.armonyBlue, font: .regularBody)
        descriptionLabel.expandedAttributedLink = less.attributed(.armonyBlue, font: .regularBody)
        descriptionLabel.numberOfLines = 4

        gradientView.configure(with: .init(orientation: .vertical, color: .advert))
    }
}

// MARK: - AdvertViewDelegate
extension AdvertViewController: AdvertViewDelegate {
    func setContentStackViewVisibility(isHidden: Bool, animated: Bool) {
        contentStackView.setHidden(isHidden, animated: animated)
    }

    func setApplyButtonButtonVisibility(isHidden: Bool) {
        sendMessageButton.isHidden = isHidden

        // FIX IT
        if let _ = viewModel.advert?.externalLink {
            sendMessageButton.setTitle("Eğitime Git", for: .normal)
        }
        else {
            sendMessageButton.setTitle(String("Advert.SendMessage", table: .home), for: .normal)
        }
    }

    func setRemoveAdvertsButtonVisibility(isHidden: Bool) {
        removeAdvertsButton.isHidden = isHidden
    }

    func configureInstructionTypesView(with presentation: MusicGenresPresentation) {
        instructionTypesView.configure(with: presentation)
        skillsView.isHidden = !presentation.items.isEmpty
    }

    func configureUserSummaryView(with presentation: UserSummaryPresentation) {
        userSummaryView.configure(with: presentation)
    }

    func setDescriptionLabel(description: String) {
        descriptionLabel.hidableText = description
    }

    func configureSkillsView(with presentation: SkillsPresentation) {
        skillsView.configure(with: presentation)
        if viewModel.shouldInfoViewIsShown {
            scrollableContentStackView.insertArrangedSubview(infoView, at: .zero)
            buttonsStackView.setCustomSpacing(spacing: .sixteen, afterView: infoView)
        }
        activateAdvertButton.isHidden = !viewModel.shouldInfoViewIsShown
    }

    func configureGenresView(with presentation: MusicGenresPresentation) {
        genresView.configure(with: presentation)
    }

    func startSendMessageButtonActivityIndicatorView() {
        sendMessageButton.startActivityIndicatorView()
    }

    func stopSendMessageButtonActivityIndicatorView() {
        sendMessageButton.stopActivityIndicatorView()
    }

    func startUserSummaryViewDotsButtonActivityIndicatorView() {
        userSummaryView.infoDotButton.startActivityIndicatorView()
    }

    func stopUserSummaryViewDotsButtonActivityIndicatorView() {
        userSummaryView.infoDotButton.stopActivityIndicatorView()
    }

    func startDeleteButtonActivityIndicatorView() {
        removeAdvertsButton.startActivityIndicatorView()
    }

    func stopDeleteButtonActivityIndicatorView() {
        removeAdvertsButton.stopActivityIndicatorView()
    }

    func startActivateAdvertButtonActivityIndicatorView() {
        activateAdvertButton.startActivityIndicatorView()
    }

    func stopActivateAdvertButtonActivityIndicatorView() {
        activateAdvertButton.stopActivityIndicatorView()
    }
}

// MARK: - UserSummaryViewDelegate
extension AdvertViewController: UserSummaryViewDelegate {
    func didTapInfoDotsButton(_ userSummaryView: UserSummaryView) {
        let reportText = String("Report", table: .common)
        let blockText = String("Block", table: .common)
        let report = AlertService.action(title: reportText) { [weak self] in
            self?.viewModel.reportActionDidTap()
        }
        let block = AlertService.action(title: blockText, style: .destructive) {
            let blockAction = AlertService.action(title: blockText, style: .destructive) {
                self.viewModel.blockUser()
            }
            let confirmation = String("Advert.Block.Confirmation", table: .home)
            let description = String("Advert.Block.Description", table: .home)
            AlertService
                .show(title: confirmation,
                      message: description,
                      actions: [blockAction, .cancel()])
        }
        let showAlert = {
            AlertService
                .actionSheet(
                    sourceView: userSummaryView.infoDotButton,
                    actions: [report, block, .cancel()]
                )
                .show(onto: self)
        }
        if AuthenticationService.shared.isAuthenticated {
            showAlert()
        }
        else {
            RegistrationCoordinator().start(registrationCompletion: showAlert, loginCompletion: showAlert)
        }
    }
}
