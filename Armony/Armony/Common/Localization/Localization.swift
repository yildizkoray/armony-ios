//
//  Localization.swift
//  Armony
//
//  Created by Koray Yıldız on 12.10.22.
//

import Foundation

public struct Localization {
    public enum Table: CustomStringConvertible {
        case account
        case backend(Backend)
        case chat
        case common
        case feedback
        case home
        case onboarding
        case placeAdvert

        private var _rawValue: String {
            switch self {
            case .account:
                return "Account"
            case .backend(let backend):
                return backend.description
            case .chat:
                return "Chat"
            case .common:
                return "Common"
            case .feedback:
                return "Feedback"
            case .home:
                return "Home"
            case .onboarding:
                return "Onboarding"
            case .placeAdvert:
                return "PlaceAdvert"
            }
        }

        public var description: String {
            return _rawValue.titled + "+Localizable"
        }
    }
}
