//
//  NSObject+Extensions.swift
//  Armony
//
//  Created by Koray Yildiz on 19.04.23.
//

import Foundation

public extension NSObject {

    private struct AssociationKeys {
        static var notificationTokens: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "notificationTokens".hashValue)!
    }

    private func setNotificationTokens(_ tokens: [NotificationToken]) {
        objc_setAssociatedObject(
            self, &AssociationKeys.notificationTokens, tokens, .OBJC_ASSOCIATION_COPY_NONATOMIC
        )
    }

    func removeAllNotifications() {
        setNotificationTokens(.empty)
    }

    func addNotifications(_ tokens: [NotificationToken]) {
        if var notificationTokens =
            objc_getAssociatedObject(self, &AssociationKeys.notificationTokens) as? [NotificationToken]
        {
            notificationTokens.append(contentsOf: tokens)
            setNotificationTokens(notificationTokens)
        }
        else {
            setNotificationTokens(tokens)
        }
    }

    func addNotifications(_ tokens: NotificationToken...) {
        addNotifications(tokens)
    }
}
