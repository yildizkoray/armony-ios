//
//  NotificationCenter+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 10.02.2022.
//

import Foundation
import UIKit

public extension NotificationCenter {

    @discardableResult
    func observe(name: Notification.Name,
                 object: Any? = nil,
                 queue: OperationQueue = .main,
                 using block: @escaping Callback<Notification>) -> NotificationToken {

        let token = addObserver(forName: name, object: object, queue: queue, using: block)
        return NotificationToken(notifier: self, token: token)
    }

    func post(notification: Notification.Name, object: Any? = nil, userInfo: [HashableKey: Any]? = nil) {
        post(name: notification, object: object, userInfo: userInfo)
    }
}

public extension Notification {
    subscript<T: Any>(key: HashableKey) -> T? {
        return userInfo?[key] as? T
    }
}

// MARK: - Notification.Name
public extension Notification.Name {

    static let accountDetailDidUpdateInSettings = Notification.Name("accountDetailDidUpdateInSettings")

    static let newAdvertDidPlace = Notification.Name("newAdvertDidPlace")
    static let advertDidRemove = Notification.Name("advertDidRemove")

    static let messageCountDidChange = Notification.Name("messageCountDidChange")

    static let passwordResetEmailDidSend = Notification.Name("passwordResetEmailDidSend")
    static let passwordResetEmailDidFail = Notification.Name("passwordResetEmailDidFail")

    static let userLoggedIn = Notification.Name("userLoggedIn")
    static let userLoggedOut = Notification.Name("userLoggedOut")

    static let didEnterBackgroundNotification = UIApplication.didEnterBackgroundNotification
    static let willEnterForegroundNotification = UIApplication.willEnterForegroundNotification

    static let deviceTokenDidReceive = Notification.Name("didRegisterForRemoteNotificationsWithDeviceToken")

    static let internetConnectionDidChange = Notification.Name("internetConnectionDidChange")

    static let newMessageDidSend = Notification.Name("newMessageDidSend")
}
