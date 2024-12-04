//
//  GetMediasTask.swift
//  Armony
//
//  Created by Koray Yıldız on 14.10.2023.
//

import Foundation
import Alamofire

struct GetMediasTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String

    init(userID: String) {
        path = "/users/\(userID)/performances"
    }
}


struct PostMediasTask: HTTPTask {
    var method: HTTPMethod = .post
    var path: String
    var body: Parameters?

    init(userID: String, request: PostMediaItemRequest) {
        path = "/users/\(userID)/performances"
        body = request.body()
    }
}

struct DeleteMediasTask: HTTPTask {
    var method: HTTPMethod = .delete
    var path: String

    init(userID: String, id: Int) {
        path = "/users/\(userID)/performances/\(id)"
    }
}
