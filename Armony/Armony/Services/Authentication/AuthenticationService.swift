//
//  AuthenticationService.swift
//  Armony
//
//  Created by Koray Yıldız on 15.02.2022.
//

import Foundation
import KeychainAccess

private struct Constants {
    public struct Key {
        static let authorization = "Authorization"
        static let refreshToken = "refreshToken"
        static let userID = "UserID"
    }
}

public final class AuthenticationService: ResetHandling {

    public static let shared = AuthenticationService(keychain: Keychain(service: Bundle.main.bundleIdentifier.emptyIfNil),
                                                     notifier: .default)

    private let keychain: Keychain
    private let notifier: NotificationCenter

    private var accessToken: String {
        return keychain[Constants.Key.authorization].emptyIfNil
    }

    public var refreshToken: String {
        return keychain[Constants.Key.refreshToken].emptyIfNil
    }

    public func identify(accessToken: String, refreshToken: String) {
        keychain[Constants.Key.authorization] = accessToken
        keychain[Constants.Key.refreshToken] = refreshToken
    }

    public var userID: String {
        return keychain[Constants.Key.userID].emptyIfNil
    }

    public var isAuthenticated: Bool {
        return keychain[Constants.Key.authorization].isNotNilOrEmpty
    }

    init(keychain: Keychain, notifier: NotificationCenter = .default) {
        self.keychain = keychain
        self.notifier = notifier
    }

    public func authenticate(accessToken: String, refreshToken: String, userID: String) {
        keychain[Constants.Key.authorization] = accessToken
        keychain[Constants.Key.refreshToken] = refreshToken
        keychain[Constants.Key.userID] = userID
    }

    public func unauthenticate() {
        keychain[Constants.Key.authorization] = nil
        keychain[Constants.Key.refreshToken] = nil
        keychain[Constants.Key.userID] = nil
    }

    public func reset() {
        unauthenticate()
    }

    public var additionalHTTPHeaders: [String: String] {
        return [Constants.Key.authorization: accessToken]
    }

    public func addLogoutHandler(_ handler: @escaping Callback<Notification>) -> NotificationToken {
        return notifier.observe(name: .userLoggedOut, using: handler)
    }

    public func addLoginHandler(_ handler: @escaping Callback<Notification>) -> NotificationToken {
        return notifier.observe(name: .userLoggedIn, using: handler)
    }
}

// MARK - AuthenticationErrorHandler
final class AuthenticationErrorHandler {
    enum AuthError: Int {
        case emailNotFound = 100001
        case invalidPassword = 100002
        case emailExist = 100007

        case unknown
    }

    public static func message(for error: APIError?) -> String {
        let errorType = AuthError(rawValue: error.ifNil(.noData).code.ifNil(.invalid)).ifNil(.unknown)

        switch errorType {
        case .emailExist:
            return "An account is already registered with this email. Try logging in instead."

        case .emailNotFound:
            return "The email you provided is not linked to any existing account."

        case .invalidPassword:
            return "Email or password is incorrect"

        case .unknown:
            return APIError.emptyData.description
        }

    }
}
