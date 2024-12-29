//
//  OnboardingViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 12.06.22.
//

import UIKit

protocol OnboardingViewDelegate: AnyObject {
    func configureUI()
    func configureCollectionView()
}

final class OnboardingViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .onboarding

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!

    @IBOutlet private weak var actionButtonsContainerView: UIStackView!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var homePageButton: UIButton!

    @IBOutlet private weak var pageControl: UIPageControl! {
        didSet {
            pageControl.tintColor = .armonyBlue
            pageControl.currentPageIndicatorTintColor = .armonyBlue
        }
    }

    private var currentIndex: Int = .zero {
        didSet {
            pageControl.currentPage = currentIndex
            actionButtonsContainerView.setHidden(currentIndex != viewModel.numberOfItemsInSection - 1, animated: true)
        }
    }

    var viewModel: OnboardingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }

    @IBAction private func registerButtonDidTap() {
        viewModel.coordinator.registration(didRegister: dismisAndSelectAccountTab)
        ScreenViewFirebaseEvent(
            name: "buttonClicked",
            parameters: [
                "screen": "Onboarding",
                "buttonType": "Register",
            ]
        ).send()

        MixPanelClickEvent(
            parameters: [
                "screen": "Onboarding",
                "buttonType": "Register",
            ]
        ).send()
    }

    @IBAction private func homePageButtonDidTap() {
        viewModel.coordinator.dismiss(animated: true, completion: nil)
        ScreenViewFirebaseEvent(
            name: "buttonClicked",
            parameters: [
                "screen": "Onboarding",
                "buttonType": "Home Page",
            ]
        ).send()


        MixPanelClickEvent(
            parameters: [
                "screen": "Onboarding",
                "buttonType": "Home Page",
            ]
        ).send()
    }

    private func selectAccountTab() {
        viewModel.coordinator.selectTab(tab: .account)
    }

    private func dismisAndSelectAccountTab() {
        dismiss(animated: true, completion: selectAccountTab)
    }
}

// MARK: - OnboardingViewDelegate
extension OnboardingViewController: OnboardingViewDelegate {
    func configureUI() {
        collectionView.backgroundColor = .clear
        view.backgroundColor = .armonyBlack

        registerButton.setTitleColor(.armonyWhite, for: .normal)
        registerButton.setTitle(String("SignUp", table: .common),
                                for: .normal)
        registerButton.titleLabel?.font = .regularSubheading

        homePageButton.setTitleColor(.armonyWhite, for: .normal)
        homePageButton.setTitle(String("Home", table: .common),
                                for: .normal)
        homePageButton.titleLabel?.font = .regularSubheading
    }

    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        collectionView.registerCells(for: [OnboardingCell.self])
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OnboardingCell = collectionView.dequeueReusableCell(for: indexPath)
        let onboarding = viewModel.onboarding(at: indexPath)
        cell.configure(with: onboarding)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}


extension OnboardingViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = view.convert(collectionView.center, to: collectionView)
        if let index = collectionView.indexPathForItem(at: center), currentIndex != index.item {
            currentIndex = index.item
        }
    }
}



