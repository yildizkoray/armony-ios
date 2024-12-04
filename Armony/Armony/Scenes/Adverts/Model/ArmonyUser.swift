//
//  ArmonyUser.swift
//  Armony
//
//  Created by Koray Yıldız on 22.11.2021.
//

import Foundation

public struct ArmonyUser: Decodable {
    let avatarURLString: String?
    let email: String?
    let id: String
    let name: String
    let token: String?

    var avatarURL: URL? {
        avatarURLString?.url
    }

    enum CodingKeys: String, CodingKey {
        case avatarURLString = "photoUrl"
        case email
        case id
        case name
        case token
    }

    // MARK: - EMPTY
    static let empty = ArmonyUser(avatarURLString: .empty, email: .empty, id: .empty, name: .empty, token: .empty)
}
