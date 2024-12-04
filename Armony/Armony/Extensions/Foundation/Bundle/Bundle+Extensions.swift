//
//  Bundle+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 14.11.2021.
//

import Foundation

extension Bundle {

    func infoDictionaryValue<T>(for key: String) -> T {
        return object(forInfoDictionaryKey: key) as! T
    }

    var urlScheme: String {
        let urlTypes: [[String: Any]] = infoDictionaryValue(for: "CFBundleURLTypes")
        if
            let urlType = urlTypes.first,
            let urlSchemes = urlType["CFBundleURLSchemes"] as? [String],
            let urlScheme = urlSchemes.first
        {
            return urlScheme
        }
        return .empty
    }

    var version: String {
        return Bundle.main.infoDictionaryValue(for: "CFBundleShortVersionString")
    }

    var buildNumber: String {
        return Bundle.main.infoDictionaryValue(for: "CFBundleVersion")
    }
}
