//
//  LiveChatCoordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 18.11.22.
//

import Foundation

final class LiveChatCoordinator: Coordinator, SelectionBottomPopUpOpening {
    typealias Controller = LiveChatViewController

    unowned var navigator: Navigator?

    init(navigator: Navigator?) {
        self.navigator = navigator
    }

    func start(with id: Int) {
        let view = createViewController()
        view.hidesBottomBarWhenPushed = true
        let viewModel = LiveChatViewModel(view: view, id: id)
        viewModel.coordinator = self

        view.viewModel = viewModel
        navigator?.pushViewController(view, animated: true)
    }
}

// MARK: - URLNavigatable
extension LiveChatCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return true
    }

    static var instance: URLNavigatable {
        return LiveChatCoordinator(navigator: nil)
    }

    static func register(navigator: URLNavigation) {

        navigator.register(coordinator: instance, pattern: .liveChat) { result in

            if let navigator = result.navigator,
               let idStr: String = result.value(forKey: "ChatID") {
                LiveChatCoordinator(navigator: navigator).start(with: Int(idStr).ifNil(Int.invalid))
            }
        }
    }
}
