//
//  PostChangePasswordTask.swift
//  Armony
//
//  Created by Koray Yildiz on 31.07.22.
//

import Foundation
import Alamofire

struct PostChangePasswordTask: HTTPTask {
    var method: HTTPMethod = .post
    var path: String = "/auth/change-password"
    var body: Parameters?

    init(request: PostChangePasswordRequest) {
        body = request.body()
    }
}
