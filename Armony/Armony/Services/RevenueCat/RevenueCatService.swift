//
//  RevenueCatService.swift
//  Armony
//
//  Created by KORAY YILDIZ on 1.08.2025.
//

import RevenueCat

private struct Constants {
    static let revenueCatAPIKey: String = "REVENUECAT_API_KEY"
}

public protocol RevenueCatServiceProtocol {
    func start()
}

public final class RevenueCatService: RevenueCatServiceProtocol {

    public static let shared: RevenueCatServiceProtocol = RevenueCatService()

    public init() {}

    public func start() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: ConfigReader.shared[Constants.revenueCatAPIKey])
    }
}
