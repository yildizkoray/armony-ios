//
//  UserDefaults.swift
//  Armony
//
//  Created by Koray Yildiz on 14.06.22.
//

import Foundation

final class Defaults: ResetHandling {

    static let shared = Defaults(defaults: .standard, configReader: .shared)

    private let defaults: UserDefaults
    private let configReader: ConfigReader

    private lazy var allKeys: [String] = DefaultsKeys.allCases.map {
        $0.key(configurator: configReader)
    }

    init(defaults: UserDefaults,
         configReader: ConfigReader) {
        self.defaults = defaults
        self.configReader = configReader
    }

    subscript(key: DefaultsKeys) -> Bool {
        get {
            return defaults.bool(forKey: key.key(configurator: configReader))
        }
        set {
            defaults.set(newValue, forKey: key.key(configurator: configReader))
        }
    }

    func reset() {
        allKeys.forEach {
            defaults.removeObject(forKey: $0)
        }
    }
}
