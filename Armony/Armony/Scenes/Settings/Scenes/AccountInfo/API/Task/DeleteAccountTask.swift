//
//  DeleteAccountTask.swift
//  Armony
//
//  Created by Koray Yildiz on 04.02.23.
//

import Foundation
import Alamofire

struct DeleteAccountTask: HTTPTask {
    var method: HTTPMethod = .delete
    var path: String

    init(userID: String) {
        path = "/users/\(userID)/account"
    }
}
