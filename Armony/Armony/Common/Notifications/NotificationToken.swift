//
//  NotificationToken.swift
//  Armony
//
//  Created by Koray Yıldız on 10.02.2022.
//

import Foundation

public final class NotificationToken: NSObject {

    private let notifier: NotificationCenter
    private let token: Any

    public init(notifier: NotificationCenter = .default, token: Any) {
        self.notifier = notifier
        self.token = token
    }

    deinit {
        notifier.removeObserver(token)
    }
}
