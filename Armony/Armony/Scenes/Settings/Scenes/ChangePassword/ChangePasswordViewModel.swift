//
//  ChangePasswordViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 31.07.22.
//

import Foundation

final class ChangePasswordViewModel: ViewModel {
    var coordinator: ChangePasswordCoordinator!
    private weak var view: ChangePasswordViewDelegate?
    
    
    init(view: ChangePasswordViewDelegate) {
        self.view = view
        super.init()
    }

    func saveButtonTapped(currentPassword: String?, newPassword: String?) {
        guard let currentPassword = currentPassword,
              let newPassword = newPassword else {
            return
        }
        view?.startSaveButtonActivityIndicatorView()

        let request = PostChangePasswordRequest(currentPassword: currentPassword, newPassword: newPassword)

        Task {
            do {
                let _ = try await service.execute(
                    task: PostChangePasswordTask(request: request),
                    type: RestObjectResponse<EmptyResponse>.self
                )
                safeSync {
                    view?.stopSaveButtonActivityIndicatorView()
                }

                let message = String("ChangePassword.Success.Message", table: .account)
                await AlertService.show(message: message,
                                        actions: [.okay(action: { [weak self] in
                    self?.coordinator.pop()
                })])
            }
            catch let error {
                safeSync {
                    view?.stopSaveButtonActivityIndicatorView()
                }
                await AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }
}

// MARK: - ViewModelLifeCycle
extension ChangePasswordViewModel: ViewModelLifeCycle {
    func viewDidLoad() {
        view?.configureUI()
    }
}
