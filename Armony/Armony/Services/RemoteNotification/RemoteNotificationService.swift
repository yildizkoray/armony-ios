//
//  RemoteNotificationService.swift
//  Armony
//
//  Created by Koray Yıldız on 25.11.22.
//

import Foundation
import UserNotifications
import UIKit.UIUserNotificationSettings

final class RemoteNotificationService: NSObject {

    static let shared = RemoteNotificationService(handlers: [FirebaseRemoteNotificationHandler.shared])

    private let handlers: [RemoteNotificationHandler]
    private let options: UNAuthorizationOptions

    init(handlers: [RemoteNotificationHandler]) {
        self.handlers = handlers
        self.options = [.badge, .sound, .alert]
    }

    func start() {
        enable()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceTokenDidReceive(notification:)),
            name: .deviceTokenDidReceive, object: nil
        )
        handlers.forEach {
            $0.initialize()
        }
    }

    @objc private func deviceTokenDidReceive(notification: Notification) {
        if let token: Data = notification[.deviceToken] {
            handlers.forEach {
                $0.handle(token: token)
            }
        }
    }

    private func enable() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: options,
            completionHandler: { _, _ in }
        )
        UIApplication.shared.registerForRemoteNotifications()
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension RemoteNotificationService: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge,.sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        if let urlString: String = response[.deeplink] {
            let deeplink = Deeplink(stringLiteral: urlString)
            URLNavigator.shared.open(deeplink)
        }
        completionHandler()
    }
}

// MARK: - UNNotificationResponse
public extension UNNotificationResponse {

    subscript<T: Any>(key: HashableKey) -> T? {
        return notification.request.content.userInfo[key.value] as? T
    }
}
