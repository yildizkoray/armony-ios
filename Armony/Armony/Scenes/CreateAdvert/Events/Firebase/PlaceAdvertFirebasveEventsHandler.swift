//
//  PlaceAdvertFirebasveEventsHandler.swift
//  Armony
//
//  Created by Koray Yıldız on 23.12.2023.
//

import Foundation

final class PlaceAdvertFirebasveEventsHandler {

    static func track(event: FirebaseEvent) {
        event.send()
    }
}
