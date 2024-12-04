//
//  LoginRequest.swift
//  Armony
//
//  Created by Koray Yildiz on 30.07.22.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}
