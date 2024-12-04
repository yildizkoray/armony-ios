//
//  GetUserTask.swift
//  Armony
//
//  Created by Koray Yildiz on 18.04.22.
//

import Alamofire
import Foundation

struct GetUserTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String

    init(id: String) {
        path = "/users/\(id)"
    }
}
