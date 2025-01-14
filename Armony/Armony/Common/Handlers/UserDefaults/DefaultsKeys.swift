//
//  DefaultsKeys.swift
//  Armony
//
//  Created by Koray Yildiz on 14.06.22.
//

import Foundation

protocol DefaultsKeyProtocol {
    var authticator: AuthenticationService { get }
    var encryptor: UserIDEncryptor { get }
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
    var authticator: AuthenticationService {
        .shared
    }
    
    var encryptor: UserIDEncryptor {
        .shared
    }
    
    private var nonUserBasedKeys: [DefaultsKeys] {
        return [
            .onboardingHasSeen,
            .isFirtRun
        ]
    }
    
    func key(configurator: ConfigReader = .shared) -> String {
        let baseKey = "\(configurator.environment.rawValue)-\(rawValue)"
        
        guard !nonUserBasedKeys.contains(self) else {
            return baseKey
        }
        
        guard authticator.userID.isNotEmpty, authticator.isAuthenticated else {
            return baseKey
        }
        
        let encryptedID = encryptor.encrypt(authticator.userID)
        return "\(baseKey)-\(encryptedID)"
    }
}
