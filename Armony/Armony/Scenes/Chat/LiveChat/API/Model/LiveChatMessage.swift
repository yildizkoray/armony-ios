//
//  Message.swift
//  Armony
//
//  Created by Koray Yıldız on 19.11.22.
//

import Foundation

struct ChatAdvert: Decodable {
    let id: Int
    let ad: Advert
}

struct LiveChatResponse: Decodable {
    let chat: ChatAdvert
    let messages: [LiveChatMessage]
    let receiver: LiveChatMessage.Owner

    enum CodingKeys: String, CodingKey {
        case chat = "chat"
        case messages
        case receiver
    }
}

struct LiveChatMessage: Codable {

    struct Owner: Codable {
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
    let owner: Owner
    let date: String
    let content: String
}
