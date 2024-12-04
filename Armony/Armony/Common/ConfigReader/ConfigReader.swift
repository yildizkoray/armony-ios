//
//  ConfigReader.swift
//  Armony
//
//  Created by Koray Yıldız on 14.11.2021.
//

import Foundation
import FirebaseRemoteConfig

private struct Constants {
    static let keyForConfig = "Config"
}

final class ConfigReader {

    enum Environment: String {
        case debug = "Debug"
        case release = "Release"
        
        var isRelease: Bool {
            return self == .release
        }
    }

    static let shared = ConfigReader()

    private typealias ConfigType = [String: Any]

    private let configs: ConfigType = Bundle.main.infoDictionaryValue(for: Constants.keyForConfig)

    var environment: Environment {
        return Environment(rawValue: self["ENVIRONMENT"])!
    }

    subscript<E>(key: String, default value: @escaping @autoclosure () -> E) -> E {
        return configs[key, default: value()] as! E
    }

    subscript(key: String) -> String {
        return self[key, default: .empty]
    }
}

// MARK: - RemoteConfigService
final class RemoteConfigService {

    static let shared = RemoteConfigService()

    private let remoteConfig = RemoteConfig.remoteConfig()

    func start() async throws {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = .zero

        remoteConfig.setDefaults(fromPlist: defaultsPlistFile())
        remoteConfig.configSettings = settings

        try await remoteConfig.fetchAndActivate()
    }

    private func defaultsPlistFile() -> String {
        return "\(ConfigReader.shared.environment.rawValue)-Remote-Config-Defaults"
    }

    // String
    subscript(key: HashableKey) -> String {
        return self[key.value]
    }

    private subscript(key: String) -> String {
        return remoteConfig[key].stringValue.emptyIfNil
    }

    // Bool
    subscript(key: HashableKey) -> Bool {
        return self[key.value]
    }

    private subscript(key: String) -> Bool {
        return remoteConfig[key].boolValue
    }
}
