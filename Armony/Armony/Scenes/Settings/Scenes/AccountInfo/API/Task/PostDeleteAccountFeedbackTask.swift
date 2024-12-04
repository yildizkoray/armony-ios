//
//  PostDeleteAccountFeedbackTask.swift
//  Armony
//
//  Created by Koray Yıldız on 9.12.2023.
//

import Foundation
import Alamofire

struct PostDeleteAccountFeedbackTask: HTTPTask {
    var method: HTTPMethod = .post
    var path: String
    var body: Parameters?

    init(request: PostDeleteAccountFeedbackRequest) {
        path = "/users/account"
        body = request.body()
    }
}

struct PostDeleteAccountFeedbackRequest: Encodable {
    let id: Int
}
