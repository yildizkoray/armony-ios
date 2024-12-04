//
//  PostCreateLiveChatTask.swift
//  Armony
//
//  Created by Koray Yildiz on 29.12.22.
//

import Foundation
import Alamofire

struct PostCreateLiveChatTask: HTTPTask {
    var method: HTTPMethod = .post
    var path: String
    var body: Parameters?

    init(userID: String, request: CreateLiveChatRequest) {
        path = "/users/\(userID)/chats"
        body = request.body()
    }
}
