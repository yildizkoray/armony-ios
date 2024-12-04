//
//  GetTitlesTask.swift
//  Armony
//
//  Created by Koray Yildiz on 11.07.22.
//

import Alamofire

struct GetTitlesTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String = "/titles"
}
