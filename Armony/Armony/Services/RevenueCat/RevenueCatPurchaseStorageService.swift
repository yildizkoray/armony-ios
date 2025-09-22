//
//  RevenueCatPurchaseStorageService.swift
//  Armony
//
//  Created by KORAY YILDIZ on 7.08.2025.
//

import KeychainAccess
import Foundation

private struct Constants {
    static let keychainServiceName = Bundle.main.bundleIdentifier.emptyIfNil + "RevenueCatPurchaseStorageService"
}

final class RevenueCatPurchaseStorageService {

    static let shared = RevenueCatPurchaseStorageService()

    private let keychain: Keychain
    private let authenticator: AuthenticationService = .shared

    private(set) var identifiers: [String] {
        get {
            keychainArray()
        }
        set {
            if let data = try? JSONSerialization.data(withJSONObject: newValue, options: []),
               let jsonString = String(data: data, encoding: .utf8) {
                try? keychain.set(jsonString, key: "identifiers-\(authenticator.userID)")
            }
        }
    }

    init(keychain: Keychain = Keychain(service: Constants.keychainServiceName)) {
        self.keychain = keychain
    }

    func store(transactionID: String) {
        identifiers.append(transactionID)
    }

    func remove(transactionID: String) {
        identifiers.removeAll {
            $0 == transactionID
        }
    }

    private func keychainArray() -> [String] {
        guard let jsonString = keychain["identifiers-\(authenticator.userID)"],
              let data = jsonString.data(using: .utf8),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] else {
            return []
        }

        return dictionary
    }
}
