//
//  UserDefaults.swift
//  Armony
//
//  Created by Koray Yildiz on 14.06.22.
//

import Foundation

final class Defaults: ResetHandling {

    static let shared = Defaults(defaults: .standard)

    private let defaults: UserDefaults

    private lazy var allKeys: [String] = DefaultsKeys.allCases.map {
        $0.key()
    }

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    /// Bool
    subscript(key: DefaultsKeys) -> Bool {
        get {
            return defaults.bool(forKey: key.key())
        }
        set {
            defaults.set(newValue, forKey: key.key())
        }
    }
    
    /// String
    subscript(key: DefaultsKeys) -> String? {
        get {
            return defaults.string(forKey: key.key())
        }
        set {
            defaults.set(newValue, forKey: key.key())
        }
    }
    
    /// TimeInterval
    subscript(key: DefaultsKeys) -> TimeInterval? {
        get {
            return defaults.double(forKey: key.key())
        }
        set {
            defaults.set(newValue, forKey: key.key())
        }
    }
    
    func reset() {
        allKeys.forEach {
            defaults.removeObject(forKey: $0)
        }
    }
}
