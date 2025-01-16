//
//  AppLaunchService.swift
//  Armony
//
//  Created by Koray Yıldız on 26.11.22.
//

import Foundation
import UIKit

enum AppLaunchType {
    case url(url: URL)
    case notification(userInfo: [AnyHashable: Any])
    case none
}

protocol AppLaunchHandling {
    var isLaunchedClosedStateWithNotification: Bool { get set }
    var deeplink: Deeplink? { get set }
}

final class AppLaunchService: AppLaunchHandling, ResetHandling {

    static let shared = AppLaunchService()

    var isLaunchedClosedStateWithNotification = false
    var deeplink: Deeplink? = nil

    @discardableResult
    func handleLaunch(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> AppLaunchType {
        guard let launchOptions = launchOptions else {
            return .none
        }

        if let url = launchOptions[UIApplication.LaunchOptionsKey.url] as? URL {
            isLaunchedClosedStateWithNotification = true
            deeplink = url.deeplink
            return .url(url: url)
        }

        if let userInfo = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            isLaunchedClosedStateWithNotification = true
            if let urlString: String = userInfo[.deeplink] {
                let deeplink = Deeplink(stringLiteral: urlString)
                self.deeplink = deeplink
            }
            return .notification(userInfo: userInfo)
        }

        return .none
    }

    func reset() {
        deeplink = nil
        isLaunchedClosedStateWithNotification = false
    }
}

private extension Dictionary where Key == AnyHashable {

    subscript<T: Any>(key: HashableKey) -> T? {
        return self[key.value] as? T
    }
}
