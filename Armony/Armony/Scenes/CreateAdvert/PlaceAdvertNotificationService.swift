//
//  PlaceAdvertNotificationService.swift
//  Armony
//
//  Created by Koray Yıldız on 23.12.2023.
//

import Foundation

final class PlaceAdvertNotificationService {
    static let shared = PlaceAdvertNotificationService()

    private var newAdvertPlaceNotificationToken: NotificationToken? = nil
    private unowned let notifier: NotificationCenter = .default

    public func addNewAdvertPlaceHandler(_ handler: @escaping Callback<Notification>) {
        newAdvertPlaceNotificationToken = notifier.observe(name: .newAdvertDidPlace, using: { [unowned self] notification in
            handler(notification)
            self.notifier.removeObserver(self.newAdvertPlaceNotificationToken as Any)
        })
    }
}

