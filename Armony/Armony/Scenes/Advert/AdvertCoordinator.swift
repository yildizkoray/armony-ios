//
//  AdvertCoordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 23.11.2021.
//

import UIKit

final class AdvertCoordinator: Coordinator, SelectionBottomPopUpOpening {

    typealias Controller = AdvertViewController

    weak var navigator: Navigator?

    private func start(id: Int, colorCode: String = .empty,
                       navigator: UIViewController,
                       isPreviousPageLiveChat: Bool,
                       isRemoveAdvertsActive: Bool = false, dismiss completion: Callback<Bool>? = nil) {
        let view = createViewController()
        let viewModel = AdvertViewModel(
            view: view,
            id: id,
            colorCode: colorCode,
            isRemovingActive: isRemoveAdvertsActive, isPreviousPageLiveChat: isPreviousPageLiveChat, dismissCompletion: completion
        )
        view.viewModel = viewModel
        viewModel.coordinator = self

        let advertNavigator = Navigator(rootViewController: view)
        defer {
            self.navigator = advertNavigator
        }
        navigator.present(advertNavigator, animated: true)
    }

    func start(with id: Int, colorCode: String,
               isRemoveAdvertsActive: Bool = false,
               isPreviousPageLiveChat: Bool = false,
               dismiss completion: Callback<Bool>? = nil) {
        if let navigator = UIViewController.topMostNavigationController {
            start(
                id: id,
                colorCode: colorCode,
                navigator: navigator,
                isPreviousPageLiveChat: isPreviousPageLiveChat,
                isRemoveAdvertsActive: isRemoveAdvertsActive,
                dismiss: completion
            )
        }
    }

    func visitedAccount(with userID: String) {
        VisitedAccountCoordinator(navigator: navigator).start(with: userID)
    }

    func liveChat(with chatID: Int) {
        LiveChatCoordinator(navigator: navigator).start(with: chatID)
    }

    func registration(didRegister: VoidCallback?, didLogin: VoidCallback?) {
        RegistrationCoordinator().start(registrationCompletion: didRegister, loginCompletion: didLogin)
    }
}

// MARK: - URLNavigatable
extension AdvertCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return false
    }

    static var instance: URLNavigatable {
        return AdvertCoordinator()
    }
    
    private static func show(with deeplink: URLNavigationResult) {
        if let view = deeplink.view,
           let idStr: String = deeplink.value(forKey: "AdvertID"),
           let id = Int(idStr) {
            AdvertCoordinator().start(id: id, navigator: view, isPreviousPageLiveChat: false)
        }
    }

    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .advert, handler: show)
    }
}
