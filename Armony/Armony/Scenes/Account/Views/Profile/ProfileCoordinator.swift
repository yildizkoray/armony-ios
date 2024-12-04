//
//  ProfileCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 31.05.22.
//

import UIKit
import SnapKit

final class ProfileCoordinator: Coordinator {
    typealias Controller = ProfileViewController

    weak var navigator: Navigator?

    init(navigator: Navigator?) {
        self.navigator = navigator
    }

    func start(with presentation: ProfilePresentation, delegate: ProfileViewModelDelegate?) {
        let view = createViewController()

        let viewModel = ProfileViewModel(view: view, presentation: presentation, delegate: delegate)
        viewModel.coordinator = self
        view.viewModel = viewModel
        
        navigator?.pushViewController(view, animated: true)
    }
    
    func profileSelection(presentation: any SelectionPresentation) {
        SelectionBottomPopUpCoordinator(navigator: navigator).start(presentation: presentation)
    }
}
