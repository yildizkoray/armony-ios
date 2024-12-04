//
//  PutChangePasswordRequest.swift
//  Armony
//
//  Created by Koray Yildiz on 31.07.22.
//

import Foundation

struct PostChangePasswordRequest: Encodable {
    let currentPassword: String
    let newPassword: String
}
