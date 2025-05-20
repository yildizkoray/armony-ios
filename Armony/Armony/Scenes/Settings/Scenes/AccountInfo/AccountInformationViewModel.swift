//
//  AccountInformationViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 21.06.22.
//

import Foundation

final class AccountInformationViewModel: ViewModel {

    var coordinator: AccountInformationCoordinator!
    private weak var view: AccountInformationViewDelegate?
    private let authenticator: AuthenticationService

    init(view: AccountInformationViewDelegate, authenticator: AuthenticationService = .shared) {
        self.view = view
        self.authenticator = authenticator
        super.init()
    }

    func saveButtonTapped(name: String) {
        if name.isNotEmpty   {
            view?.startSaveButtonActivityIndicatorView()
            let request = PutAccountInfoRequest(name: name)
            Task {
                do {
                    let _ = try await service.execute(
                        task: PutAccountInfoTask(userID: authenticator.userID, request: request),
                        type: RestObjectResponse<EmptyResponse>.self
                    )
                    safeSync {
                        view?.stopSaveButtonActivityIndicatorView()
                        NotificationCenter.default.post(notification: .accountDetailDidUpdateInSettings)
                    }
                    let message = String("AccountInformation.Update.Succes.Message", table: .common)
                    await AlertService.show(message: message,
                                            actions: [.okay(action: { [weak self] in
                        self?.coordinator.pop()
                    })])
                }
                catch let error {
                    await AlertService.show(error: error.api, actions: [.okay()])
                    safeSync {
                        view?.stopSaveButtonActivityIndicatorView()
                    }
                }
            }
        }
    }

    func deleteAccountButtonTapped() {
        view?.startDeleteAccountButtonActivityIndicatorView()
        view?.startSaveButtonActivityIndicatorView()
        Task {
            do {
                let response = try await service.execute(
                    task: GetFeedbackSubjectsTask(with: .removeAccount),
                    type: RestArrayResponse<FeedbackSubject>.self
                )

                let items: [DeleteAccountFeedbackSelectionInput] = response.data.map { subject in
                    return DeleteAccountFeedbackSelectionInput(
                        id: subject.id, isSelected: false, title: subject.title
                    )
                }

                safeSync {
                    let selectionPresentation = DeleteAccountFeedbackSelection(items: items, delegate: self)
                    view?.stopDeleteAccountButtonActivityIndicatorView()
                    view?.stopSaveButtonActivityIndicatorView()
                    coordinator.selectionBottomPopUp(presentation: selectionPresentation)
                }
            }
            catch let error {
                error.showAlert()
                safeSync {
                    view?.stopDeleteAccountButtonActivityIndicatorView()
                    view?.stopSaveButtonActivityIndicatorView()
                }
            }
        }
    }

    func deleteAccount(feedback: FeedbackRequest) {
        view?.startDeleteAccountButtonActivityIndicatorView()
        view?.startSaveButtonActivityIndicatorView()

        Task {
            do {
                let _ = try await service.execute(
                    task: PostFeedbackTask(request: feedback),
                    type: RestObjectResponse<EmptyResponse>.self
                )
                let _ = try await service.execute(
                    task: DeleteAccountTask(userID: authenticator.userID),
                    type: RestObjectResponse<EmptyResponse>.self
                )

                DeleteAccountFirebaseEvent(
                    explanation: feedback.feedbackSubject.title
                ).send()
                DeleteAccountAdjustEvent().send()

                safeSync {
                    ApplicationResetHandler.shared.reset()
                    coordinator.startFromSktratch()
                }
            }
            catch let error {
                safeSync {
                    view?.stopDeleteAccountButtonActivityIndicatorView()
                    view?.stopSaveButtonActivityIndicatorView()
                }
                error.showAlert()
            }
        }

    }
}

// MARK: - ViewModelLifeCycle
extension AccountInformationViewModel: ViewModelLifeCycle {
    func viewDidLoad() {
        view?.configureUI()
        view?.setContainerViewVisibility(isHidden: true)
        view?.startActivityIndicatorView()

        Task {
            do {
                let response = try await service.execute(
                    task: GetAccountInfoTask(userID: authenticator.userID),
                    type: RestObjectResponse<AccountInfo>.self
                )

                safeSync {
                    view?.stopActivityIndicatorView()
                    view?.setContainerViewVisibility(isHidden: false)
                    view?.configureEmailTextField(email: response.data.email)
                    view?.configureNameTextField(name: response.data.name)
                }
            }
            catch let error {
                await AlertService.show(error: error.api, actions: [.okay()])
                safeSync {
                    view?.stopActivityIndicatorView()
                }
            }
        }
    }
}

// MARK: - DeleteAccountFeedbackSelectionDelegate
extension AccountInformationViewModel: DeleteAccountFeedbackSelectionDelegate {
    func deleteAccountFeedbackDidSelect(output: DeleteAccountFeedbackSelectionInput?) {
        guard let output = output else {
            return
        }
        let request = FeedbackRequest(
            feedbackSubject: FeedbackSubject(id: output.id, title: output.title),
            message: .empty
        )
        let removeAction = AlertService.action(title: "Delete Account", style: .destructive, action: { [weak self] in
            self?.deleteAccount(feedback: request)
        })
        AlertService.show(message: "Are you sure you want to delete your account?",
                          actions: [removeAction, .cancel()])
    }
}


// MARK: - Events

struct DeleteAccountFirebaseEvent: FirebaseEvent {
    var name: String = "delete_account"
    var category: String = "Account"
    var action: String = "Delete"
    var parameters: Payload

    init(explanation: String) {
        parameters = [
            "reason": explanation
        ]
    }
}

struct DeleteAccountAdjustEvent: AdjustEvent {
    var token: String = "hsexdf"
}
