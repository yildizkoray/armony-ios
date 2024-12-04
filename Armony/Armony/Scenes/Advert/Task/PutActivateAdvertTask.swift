//
//  PutActivateAdvertTask.swift
//  Armony
//
//  Created by Koray Yıldız on 27.02.2024.
//

import Foundation
import Alamofire

struct PutActivateAdvertTask: HTTPTask {
    var method: HTTPMethod = .put
    var path: String

    init(advertID: String, userID: String) {
        path = "/users/\(userID)/ads/\(advertID)/activate"
    }
}
