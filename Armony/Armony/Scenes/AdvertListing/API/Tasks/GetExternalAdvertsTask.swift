//
//  GetExternalAdvertsTask.swift
//  Armony
//
//  Created by KORAY YILDIZ on 02/10/2024.
//

import Foundation
import Alamofire

struct GetExternalAdvertsTask: HTTPTask {

    var method: Alamofire.HTTPMethod = .get
    var path: String = "/external-ads"
}
