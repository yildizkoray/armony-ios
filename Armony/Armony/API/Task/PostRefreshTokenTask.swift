//
//  PostRefreshTokenTask.swift
//  Armony
//
//  Created by Koray Yildiz on 02.08.22.
//

import Foundation
import Alamofire

struct PostRefreshTokenTask: HTTPTask {
    var method: HTTPMethod = .post
    var path: String = "/auth/refresh"
    var body: Parameters?

    init(request: RefreshTokenRequest) {
        body = request.body()
    }
}

// MARK: - RefreshTokenRequest
struct RefreshTokenRequest: Encodable {
    let refreshToken: String
}

// MARK: - RefreshTokenResponse
struct RefreshTokenResponse: Decodable {
    let access: String
    let refresh: String

    enum CodingKeys: String, CodingKey {
        case access = "accessToken"
        case refresh = "refreshToken"
    }
}
