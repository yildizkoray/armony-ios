//
//  DeleteUserAdvertTask.swift
//  Armony
//
//  Created by Koray Yıldız on 01.11.22.
//

import Foundation
import Alamofire

struct DeleteUserAdvertTask: HTTPTask {
    var method: HTTPMethod = .delete
    var path: String

    init(userID: String, advertID: Int) {
        path = "/users/\(userID)/ads/\(advertID)"
    }
}
