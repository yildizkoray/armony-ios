//
//  GetChatsTask.swift
//  Armony
//
//  Created by Koray Yıldız on 18.11.22.
//

import Alamofire
import Foundation

struct GetChatsTask: HTTPTask, PaginatableTask {
    var page: Int = 1
    var method: HTTPMethod = .get
    var path: String

    var urlQueryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "page", value: page.string)]
    }

    init(userID: String) {
        path = "/users/\(userID)/chats"
    }
}

struct SocketMessageReadCountTask: HTTPTask {
    var method: Alamofire.HTTPMethod = .get
    var path: String

    init(userID: String) {
        path = "/users/\(userID)/unread-messages-count"
    }
}
