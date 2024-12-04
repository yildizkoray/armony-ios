//
//  CreateLiveChatResponse.swift
//  Armony
//
//  Created by Koray Yildiz on 29.12.22.
//

import Foundation

struct CreateLiveChatResponse: Decodable {
    let chatID: Int

    enum CodingKeys: String, CodingKey {
        case chatID = "chatId"
    }
}
