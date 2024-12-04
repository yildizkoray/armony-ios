//
//  LogOutBottomViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 10.07.22.
//

import Foundation

final class LogOutBottomPopUpViewModel: ViewModel {

    var coordinator: LogOutBottomPopUpCoordinator!

    private weak var view: LogOutBottomPopUpViewDelegate?
    private let authenticator: AuthenticationService

    private let notifier: NotificationCenter = .default

    init(view: LogOutBottomPopUpViewDelegate,
         authenticator: AuthenticationService = .shared) {
        self.view = view
        self.authenticator = authenticator
        super.init()
    }

    func logOut() {
        view?.startLogoutButtonActivityIndicatorView()
        Task {
            do {
                let _ = try await service.execute(
                    task: PostLogoutTask(),
                    type: RestObjectResponse<EmptyResponse>.self
                )

                authenticator.unauthenticate()
                notifier.post(notification: .userLoggedOut)

                AdjustLogOutEvet().send()

                safeSync {
                    view?.stopLogoutButtonActivityIndicatorView()
                    coordinator.dismiss(animated: true) { [weak self] in
                        self?.coordinator.popToRootViewController(animated: false)
                        self?.coordinator.selectTab(tab: .home, shouldPopToRoot: true)
                    }
                }
            }
            catch {
                safeSync {
                    view?.stopLogoutButtonActivityIndicatorView()
                }
            }
        }
    }
}

struct AdjustLogOutEvet: AdjustEvent {
    var token: String = "6rjyuv"
}
