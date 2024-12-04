//
//  Localization.swift
//  Armony
//
//  Created by Koray Yıldız on 12.10.22.
//

import Foundation

public struct Localization { 
    public enum Table: String, CustomStringConvertible {
        case account
        case chat
        case common
        case home
        case placeAdvert

        public var description: String {
            return rawValue.titled + "+Localizable"
        }
    }
}
