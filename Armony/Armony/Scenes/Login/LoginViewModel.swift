//
//  LoginViewModel.swift
//  Armony
//
//  Created by Koray Yıldız on 25.01.2022.
//

import Foundation

final class LoginViewModel: ViewModel {

    var coordinator: LoginCoordinator!
    private weak var view: LoginViewDelegate?
    private let authenticator: AuthenticationService

    private(set) var registrationCompletion: VoidCallback?
    private(set) var loginCompletion: VoidCallback?

    private unowned var notifier: NotificationCenter

    init(view: LoginViewDelegate,
         loginCompletion: VoidCallback?,
         registrationCompletion: VoidCallback?,
         authenticator authenticationService: AuthenticationService = .shared,
         notifier: NotificationCenter = .default) {
        self.authenticator = authenticationService
        self.notifier = notifier
        self.view = view
        self.loginCompletion = loginCompletion
        self.registrationCompletion = registrationCompletion
        super.init()
    }

    func forgetPasswordButtonTapped(email: String) {
        coordinator.showForgotPasswordView(email: email) { [weak self] email in
            self?.sendPasswordReset(withEmail: email)
        }
    }

    private func sendPasswordReset(withEmail email: String) {
        Task {
            do {
                let request = ForgetPasswordRequest(email: email)
                let _ = try await service.execute(
                    task: PostForgetPasswordTask(request: request),
                    type: RestObjectResponse<EmptyResponse>.self
                )

                self.notifier.post(name: .passwordResetEmailDidFail, object: self)

                AlertService.show(message: "\(email) adresine parolanizi sifirlamaniz icin email gonderildi.", actions: await [.okay(action: { [weak self] in
                    self?.notifier.post(name: .passwordResetEmailDidSend, object: self)
                })])
            }
            catch let error {
                await AlertService.show(message: AuthenticationErrorHandler.message(for: error.api), actions: [.okay()])
                self.notifier.post(name: .passwordResetEmailDidFail, object: self)
            }
        }
    }

    func login(with credential: LoginCredential) {
        guard credential.password.isNotEmpty,
              credential.email.isNotEmpty else {
            return
        }

        view?.startLoginButtonActivityIndicatorView()

        Task {
            do {
                // Login
                let request = LoginRequest(email: credential.email, password: credential.password)
                let response = try await service.execute(
                    task: PostLoginTask(request: request),
                    type: RestObjectResponse<Token>.self
                )
                // FCMToken
                let updateFCMTokenRequest = FCMTokenRequest(fcmToken: FirebaseRemoteNotificationHandler.shared.fcmToken.emptyIfNil)
                let _ = try? await service.execute(
                    task: PutFCMTokenTask(request: updateFCMTokenRequest, userID: response.data.userID),
                    type: RestObjectResponse<EmptyResponse>.self
                )
                authenticator.authenticate(accessToken: response.data.access,
                                           refreshToken: response.data.refresh,
                                           userID: response.data.userID)

                let armonyUser = ArmonyUser(avatarURLString: nil, email: credential.email, id: response.data.userID, name: "", token: nil)
                notifier.post(notification: .userLoggedIn, object: self, userInfo: [.user: armonyUser])

                safeSync {
                    coordinator.dismiss(animated: true, completion: loginCompletion)
                }
                LoginFirebaseEvent(label: response.data.userID).send()
                AdjustLoginEvent().send()
            }
            catch let error {
                await AlertService.show(message: AuthenticationErrorHandler.message(for: error.api), actions: [.okay()])
            }
            safeSync {
                view?.stopLoginButtonActivityIndicatorView()
            }
        }
    }
}

// MARK : ViewModelLifeCycle
extension LoginViewModel: ViewModelLifeCycle {

    func viewDidLoad() {
        view?.configureUI()
        view?.makeNavigationBarTransparent()
        view?.setDismissButton(completion: nil)
    }
}

// MARK: - Events
struct AdjustLoginEvent: AdjustEvent {
    var token: String = "ocxbrz"
}
