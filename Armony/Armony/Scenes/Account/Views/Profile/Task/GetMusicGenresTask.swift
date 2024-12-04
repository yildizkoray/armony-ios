//
//  GetMusicGenresTask.swift
//  Armony
//
//  Created by Koray Yildiz on 05.06.22.
//

import Alamofire

struct GetMusicGenresTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String = "/genres"
}
