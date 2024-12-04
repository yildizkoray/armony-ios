//
//  UpdateAccountInfo.swift
//  Armony
//
//  Created by Koray Yildiz on 27.07.22.
//

import Foundation
import Alamofire

struct PutAccountInfoTask: HTTPTask {
    var method: HTTPMethod = .put
    var path: String
    var body: Parameters?

    init(userID: String, request: PutAccountInfoRequest) {
        path = "/users/\(userID)/account"
        body = request.body()
    }
}
