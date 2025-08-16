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
        case chat
        case common
        case home
        case onboarding
        case placeAdvert
        case backend(Backend)

        private var _rawValue: String {
            switch self {
            case .account:
                return "Account"
            case .chat:
                return "Chat"
            case .common:
                return "Common"
            case .home:
                return "Home"
            case .onboarding:
                return "Onboarding"
            case .placeAdvert:
                return "PlaceAdvert"
            case .backend(let backend):
                return backend.description
            }
        }

        public var description: String {
            return _rawValue.titled + "+Localizable"
        }
    }
}
