//
//  GetMessagesTask.swift
//  Armony
//
//  Created by Koray Yıldız on 19.11.22.
//

import Foundation
import Alamofire

struct GetLiveChatMessagesTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String

    init(userID: String, chatID: Int) {
        path = "/users/\(userID)/chats/\(chatID)/messages"
    }
}
