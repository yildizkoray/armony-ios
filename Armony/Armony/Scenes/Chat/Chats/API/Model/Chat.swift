//
//  Chat.swift
//  Armony
//
//  Created by Koray Yıldız on 18.11.22.
//

import Foundation

struct Chat: Decodable {
    struct User: Decodable {
        let id: String
        let name: String
        private let avatarURLString: String?

        var avatarURL: URL? {
            return avatarURLString?.url
        }

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case avatarURLString = "photoUrl"
        }
    }

    let id: Int
    let lastMessage: String
    let user: User
    let isRead: Bool
}
