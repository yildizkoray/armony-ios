//
//  GetUserAdvertsTask.swift
//  Armony
//
//  Created by Koray Yildiz on 24.05.22.
//

import Alamofire

struct GetUserAdvertsTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String

    init(userID: String) {
        path = "/users/\(userID)/ads"
    }
}
