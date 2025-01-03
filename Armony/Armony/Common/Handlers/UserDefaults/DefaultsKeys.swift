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
    case region
    case isRegionActive
    case lastAppReviewRequestDate = "lastAppReviewRequestDate"
}

// MARK: - DefaultsKeyProtocol
extension DefaultsKeys: DefaultsKeyProtocol {
    
    private var nonUserBasedKeys: [DefaultsKeys] {
        return [
            .onboardingHasSeen,
            .isFirtRun
        ]
    }
    
    func key(configurator: ConfigReader = .shared) -> String {
        let baseKey = "\(configurator.environment.rawValue)-\(rawValue)"
        let userID = AuthenticationService.shared.userID
        
        guard !nonUserBasedKeys.contains(self) else {
            return baseKey
        }
        
        guard userID.isNotEmpty else {
            return baseKey
        }
        
        let encryptedID = UserIDEncryptor.shared.encrypt(userID)
        return "\(baseKey)-\(encryptedID)"
        
    }
}
