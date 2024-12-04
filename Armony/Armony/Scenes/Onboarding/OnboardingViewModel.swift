//
//  OnboardingViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 13.06.22.
//

import Foundation

final class OnboardingViewModel: ViewModel {

    var coordinator: OnboardingCoordinator!
    private unowned var view: OnboardingViewDelegate

    private let presentation: [OnboardingPresentation] = [
        OnboardingPresentation(borderImageName: "onboarding-first-border",
                               contentImageName: "onboarding-first-content",
                               text: "Müzisyen ve\nmüzik grupları"),
        OnboardingPresentation(borderImageName: "onboarding-second-border",
                               contentImageName: "onboarding-second-content",
                               text: "Müzik eğitimleri ve\netkinlik hizmetleri"),
        OnboardingPresentation(borderImageName: "onboarding-third-border",
                               contentImageName: "onboarding-third-content",
                               text: "Profesyonel müzik\nhizmetleri")
    ]

    var numberOfItemsInSection: Int {
        return presentation.count
    }

    init(view: OnboardingViewDelegate) {
        self.view = view
        super.init()
    }

    func onboarding(at indexPath: IndexPath) -> OnboardingPresentation {
        return presentation[indexPath.row]
    }
}

// MARK: - ViewModelLifeCycle
extension OnboardingViewModel: ViewModelLifeCycle {
    func viewDidLoad() {
        view.configureUI()
        view.configureCollectionView()

        Defaults.shared[.onboardingHasSeen] = true
        ScreenViewFirebaseEvent(
            name: "screenView",
            parameters: [
                "screen": "Onboarding",
            ]
        ).send()

        MixPanelScreenViewEvent(
            parameters: [
                "screen": "Onboarding",
            ]
        ).send()
    }
}
