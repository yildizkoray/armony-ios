//
//  GetAdvertTask.swift
//  Armony
//
//  Created by Koray Yıldız on 19.01.2022.
//

import Foundation
import Alamofire

struct GetAdvertTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String = "/ads"

    init(id: Int) {
        path += "/\(id)"
    }
}
