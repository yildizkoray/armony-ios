//
//  PostPlaceAdvertTask.swift
//  Armony
//
//  Created by Koray Yıldız on 05.10.22.
//

import Foundation
import Alamofire

struct PostPlaceAdvertTask: HTTPTask {
    var path: String = "/ads"
    var method: HTTPMethod = .post
    var body: Parameters?

    init(request: PlaceAdvertRequest) {
        body = request.body()
    }
}
