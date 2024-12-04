//
//  PostForgetPasswordTask.swift
//  Armony
//
//  Created by Koray Yıldız on 05.11.22.
//

import Foundation
import Alamofire

// MARK: - ForgetPassword
struct PostForgetPasswordTask: HTTPTask {
    var method: HTTPMethod = .post
    var path: String = "/auth/reset-password"
    var body: Parameters?

    init(request: ForgetPasswordRequest) {
        body = request.body()
    }
}

struct ForgetPasswordRequest: Encodable {
    let email: String
}

// MARK: - FCMToken
struct PutFCMTokenTask: HTTPTask {
    var method: HTTPMethod = .put
    var body: Parameters?
    var path: String

    init(request: FCMTokenRequest, userID: String) {
        self.path = "/users/\(userID)/fcm-token"
        body = request.body()
    }
}

struct FCMTokenRequest: Encodable {
    let fcmToken: String
}
