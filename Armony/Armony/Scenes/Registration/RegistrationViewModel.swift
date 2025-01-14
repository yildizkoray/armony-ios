//
//  File.swift
//  Armony
//
//  Created by Koray Yıldız on 1.02.2022.
//

import Foundation

final class RegistrationViewModel: ViewModel {

    var coordinator: RegistrationCoordinator!

    private weak var view: RegistrationViewDelegate?
    private unowned var notifier: NotificationCenter
    private let authenticator: AuthenticationService

    private(set) var registrationCompletion: VoidCallback?
    private(set) var loginCompletion: VoidCallback?

    init(view: RegistrationViewDelegate,
         registrationCompletion: VoidCallback?,
         loginCompletion: VoidCallback?,
         notifier: NotificationCenter = .default,
         authenticationService authenticator: AuthenticationService = .shared) {
        self.view = view
        self.registrationCompletion = registrationCompletion
        self.loginCompletion = loginCompletion
        self.notifier = notifier
        self.authenticator = authenticator
        super.init()
    }

    // Singup
    func signup(credential: SignupCredential) {
        guard let view = view else { return }

        guard credential.name.isNotEmpty,
              credential.email.isNotEmpty,
              credential.password.isNotEmpty else {
            return
        }
        
        view.startOkButtonActivityIndicatorView()

        Task {
            do {
                let request = SignupRequest(
                    credential: credential,
                    fcmToken: FirebaseRemoteNotificationHandler.shared.fcmToken.emptyIfNil
                )
                let response = try await service.execute(
                    task: PostSignupTask(request: request),
                    type: RestObjectResponse<Token>.self
                )
                authenticator.authenticate(
                    accessToken: response.data.access,
                    refreshToken: response.data.refresh,
                    userID: response.data.userID
                )

                let user = ArmonyUser(
                    avatarURLString: nil,
                    email: credential.email,
                    id: response.data.userID,
                    name: .empty,
                    token: .empty
                )
                notifier.post(notification: .userLoggedIn, object: self, userInfo: [.user: user])
                safeSync {
                    coordinator.dismiss(animated: true, completion: self.registrationCompletion)
                }

                RegisterFirebaseEvent(label: response.data.userID).send()
                AdjustRegistrationEvent().send()
            }
            catch let error {
                await AlertService.show(message: AuthenticationErrorHandler.message(for: error.api), actions: [.okay()])
            }
            safeSync {
                view.stopOkButtonActivityIndicatorView()
            }
        }
    }
}

// MARK: - ViewModelLifeCycle
extension RegistrationViewModel: ViewModelLifeCycle {

    func viewDidLoad() {
        view?.configureUI()
        view?.makeNavigationBarTransparent()
        view?.setDismissButton(completion: nil)
        MixPanelScreenViewEvent(parameters: ["screen": "Registration"]).send()
    }
}

// MARK: - Events
struct AdjustRegistrationEvent: AdjustEvent {
    var token: String = "phyqiv"
}
