//
//  RegisterRequest.swift
//  Armony
//
//  Created by Koray Yildiz on 28.07.22.
//

import Foundation

struct SignupRequest: Encodable {
    let name: String
    let email: String
    let password: String
    let fcmToken: String

    init(credential: SignupCredential, fcmToken: String) {
        name = credential.name
        email = credential.email
        password = credential.password
        self.fcmToken = fcmToken
    }
}

struct Token: Decodable {
    let access: String
    let refresh: String
    let userID: String

    enum CodingKeys: String, CodingKey {
        case access = "accessToken"
        case refresh = "refreshToken"
        case userID = "userId"
    }
}
