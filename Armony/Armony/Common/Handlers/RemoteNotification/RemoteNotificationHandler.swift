//
//  RemoteNotificationHandler.swift
//  Armony
//
//  Created by Koray Yıldız on 25.11.22.
//

import Foundation
import UserNotifications

protocol RemoteNotificationHandler {

    func initialize()
    func handle(token: Data)
}
