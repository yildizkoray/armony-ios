//
//  DefaultsKeys.swift
//  Armony
//
//  Created by Koray Yildiz on 14.06.22.
//

import Foundation

protocol DefaultsKeyProtocol {
    func key(configurator: ConfigReader) -> String
}

enum DefaultsKeys: String, CaseIterable {
    case onboardingHasSeen = "onboardingHasSeen"
    case isFirtRun = "isFirstRun"
}

// MARK: - DefaultsKeyProtocol
extension DefaultsKeys: DefaultsKeyProtocol {

    func key(configurator: ConfigReader) -> String {
        return "\(configurator.environment.rawValue)-\(rawValue)"
    }
}
