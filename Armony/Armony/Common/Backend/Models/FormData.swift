//
//  FormData.swift
//  Armony
//
//  Created by Koray Yıldız on 03.11.22.
//

import Foundation

public struct FormData {

    public enum MimeType: String, CustomStringConvertible {
        case jpg
        case png

        public var description: String {
            switch self {
            case .jpg:
                return "image/jpeg"
            case .png:
                return "image/png"
            }
        }
    }

    public let data: Data
    public let key: String
    public let type: MimeType

    public var name: String {
        return "\(key).\(type.rawValue)"
    }
}
