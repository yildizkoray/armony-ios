//
//  AppLaunchService.swift
//  Armony
//
//  Created by Koray Yıldız on 26.11.22.
//

import Foundation

protocol AppLaunchHandling {
    var isLaunchedClosedStateWithNotification: Bool { get set }
    var deeplink: Deeplink? { get set }
}

final class AppLaunchService: AppLaunchHandling, ResetHandling {
    
    static let shared = AppLaunchService()

    var isLaunchedClosedStateWithNotification = false
    var deeplink: Deeplink? = nil

    func reset() {
        deeplink = nil
        isLaunchedClosedStateWithNotification = false
    }
}
