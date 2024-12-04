//
//  MessagesCoordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 16.11.22.
//

import UIKit

final class ChatsCoordinator: Coordinator {

    typealias Controller = ChatsViewController

    weak var navigator: Navigator?

    init(navigator: Navigator?) {
        self.navigator = navigator
    }

    func start() {
        let view = createViewController()
        view.hidesBottomBarWhenPushed = true
        
        let viewModel = ChatsViewModel(view: view)
        viewModel.coordinator = self
        view.viewModel = viewModel

        navigator?.pushViewController(view, animated: true)
    }

    func chat(id: Int) {
        LiveChatCoordinator(navigator: navigator).start(with: id)
    }
}

// MARK: - URLNavigatable
extension ChatsCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return true
    }
    
    static var instance: URLNavigatable {
        return ChatsCoordinator(navigator: nil)
    }
    
    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .chats) { result in
            ChatsCoordinator(navigator: result.navigator).start()
        }
    }
}
