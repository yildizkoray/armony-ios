//
//  SocketLiveChatTask.swift
//  Armony
//
//  Created by Koray Yildiz on 29.12.22.
//

import Foundation
import Alamofire

struct SocketLiveChatTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String

    init(userID: String, chatID: Int) {
        path = "/users/\(userID)/chats/\(chatID)"
    }
}
