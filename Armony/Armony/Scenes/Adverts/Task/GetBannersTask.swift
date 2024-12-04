//
//  GetBannersTask.swift
//  Armony
//
//  Created by Koray Yıldız on 8.02.2024.
//

import Alamofire

struct GetBannersTask: HTTPTask {
    var path: String = "/banners"
    var method: HTTPMethod = .get
}
