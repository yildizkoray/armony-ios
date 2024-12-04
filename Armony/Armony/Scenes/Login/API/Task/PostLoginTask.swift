//
//  PostLoginTask.swift
//  Armony
//
//  Created by Koray Yildiz on 30.07.22.
//

import Foundation
import Alamofire

struct PostLoginTask: HTTPTask {
    var method: HTTPMethod = .post
    var path: String = "/auth/signin"
    var body: Parameters?

    init(request: LoginRequest) {
        body = request.body()
    }
}
