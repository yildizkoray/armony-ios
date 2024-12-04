//
//  PostSignupTask.swift
//  Armony
//
//  Created by Koray Yildiz on 28.07.22.
//

import Foundation
import Alamofire

struct PostSignupTask: HTTPTask {
    var method: HTTPMethod = .post
    var path: String = "/auth/signup"
    var body: Parameters?

    init(request: SignupRequest) {
        body = request.body()
    }
}
