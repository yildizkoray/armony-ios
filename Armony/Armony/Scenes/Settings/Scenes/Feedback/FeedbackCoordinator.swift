//
//  FeedbackCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 17.07.22.
//

import UIKit

final class FeedbackCoordinator: Coordinator {

    typealias Controller = FeedbackViewController
    
    weak var navigator: Navigator?
    
    init(navigator: Navigator? = nil) {
        self.navigator = navigator
    }

    func start() {
        let view = createViewController()
        let viewModel = FeedbackViewModel(view: view)
        viewModel.coordinator = self
        view.viewModel = viewModel
        navigator?.pushViewController(view, animated: true)
    }

    func selectionBottomPopUp(with presentation: any SelectionPresentation) {
        SelectionBottomPopUpCoordinator(navigator: navigator).start(presentation: presentation)
    }
}

// MARK: - URLNavigatable
extension FeedbackCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return true
    }

    static var instance: URLNavigatable {
        return FeedbackCoordinator()
    }
    
    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .feedback) { result in
            FeedbackCoordinator(navigator: result.navigator).start()
        }
    }
}
