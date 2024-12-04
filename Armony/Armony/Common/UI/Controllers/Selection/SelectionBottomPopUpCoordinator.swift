//
//  ProfileSelectionCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 03.06.22.
//

import UIKit

protocol SelectionBottomPopUpOpening {
    func selectionBottomPopUp(presentation: any SelectionPresentation)
}

extension SelectionBottomPopUpOpening where Self: Coordinator {
    func selectionBottomPopUp(presentation: any SelectionPresentation) {
        SelectionBottomPopUpCoordinator(navigator: navigator).start(presentation: presentation)
    }
}

final class SelectionBottomPopUpCoordinator: Coordinator {
    typealias Controller = SelectionBottomPopUpViewController

    weak var navigator: Navigator?

    init(navigator: Navigator?) {
        self.navigator = navigator
    }

    func start(presentation: any SelectionPresentation) {
        let view = createViewController()
        let viewModel = SelectionBottomPopUpViewModel(view: view, presentation: presentation)
        viewModel.coordinator = self
        view.viewModel = viewModel
        navigator?.present(view, animated: true)
    }

    func dismiss(completion: @escaping VoidCallback) {
        navigator?.dismiss(animated: true, completion: completion)
    }
}
