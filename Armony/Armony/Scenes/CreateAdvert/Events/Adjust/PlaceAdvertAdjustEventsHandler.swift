//
//  PlaceAdvertAdjustEventsHandler.swift
//  Armony
//
//  Created by Koray Yıldız on 23.12.2023.
//

import Foundation

enum AdvertTypes: Int {
    case band = 1
    case musician = 2
    case rental = 3
}

enum AdjustPlaceAdvertEvents: String, AdjustEvent {
    case musician = "druy90"
    case band = "h6p2zc"
    case rental = "i61qp5"

    var token: String {
        return rawValue
    }
}

final class PlaceAdvertAdjustEventsHandler {
    static func track(for advertID: Int) {
        if let type = AdvertTypes(rawValue: advertID) {
            switch type {
            case .musician:
                AdjustPlaceAdvertEvents.musician.send()
            case .band:
                AdjustPlaceAdvertEvents.band.send()
            case .rental:
                AdjustPlaceAdvertEvents.rental.send()
            }
        }
    }
}
