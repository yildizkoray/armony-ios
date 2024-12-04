//
//  GetAccountInfoTask.swift
//  Armony
//
//  Created by Koray Yildiz on 31.07.22.
//

import Foundation
import Alamofire

struct GetAccountInfoTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String

    init(userID: String) {
        path = "/users/\(userID)/account"
    }
}
