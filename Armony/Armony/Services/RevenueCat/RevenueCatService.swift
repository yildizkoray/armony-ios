//
//  RevenueCatService.swift
//  Armony
//
//  Created by KORAY YILDIZ on 1.08.2025.
//

import RevenueCat
import Foundation

private struct Constants {
    static let revenueCatAPIKey: String = "REVENUECAT_API_KEY"
}

public protocol RevenueCatServiceProtocol {
    func start()
}

public final class RevenueCatService: NSObject, RevenueCatServiceProtocol {

    public static let shared: RevenueCatServiceProtocol = RevenueCatService()

    private let authenticator: AuthenticationService = .shared

    public override init() {}

    public func start() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: ConfigReader.shared[Constants.revenueCatAPIKey], appUserID: authenticator.userID)

        addNotifications(
            authenticator.addLoginHandler({ _ in
                Task {
                    try? await Purchases.shared.logIn(self.authenticator.userID)
                }
            }),
            authenticator.addLogoutHandler({ _ in
                Task {
                    try? await Purchases.shared.logOut()
                }
            })
        )
    }
}
