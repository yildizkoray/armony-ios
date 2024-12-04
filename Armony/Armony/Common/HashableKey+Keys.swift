//
//  HashableKey+Keys.swift
//  Armony
//
//  Created by Koray Yildiz on 17.02.23.
//

import Foundation

public extension HashableKey {
    // MARK: Deeplink
    static let deeplink: HashableKey = "deeplink"

    // MARK: - Device Token

    static let deviceToken: HashableKey = "deviceToken"

    // MARK: - Internet Connection
    static let isConnectedToInternet: HashableKey = "isConnected"

    // MARK: - ADVERT
    static let advert: HashableKey = "advert"
    static let advertID: HashableKey = "advertID"

    static let user: HashableKey = "userSummary"

    static let messageCount: HashableKey = "messageCount"

    static let selectedTabIndex: HashableKey = "selectedTabIndex"

    // MARK: - Remote Config
    static let isNewAsyncAwaitEnabled: HashableKey = "IS_NEW_ASYNC_AWAIT_ENABLED"
    static let apiVersion: HashableKey = "API_VERSION"
    static let apiHost: HashableKey = "API_HOST"
    static let apiScheme: HashableKey = "API_SCHEME"
    static let settingsData: HashableKey = "SettingsData_136"
    static let bannerSliderData: HashableKey = "HOME_BANNER_DATA"
}
