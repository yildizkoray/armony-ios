//
//  GetSettingsTask.swift
//  Armony
//
//  Created by KORAY YILDIZ on 30/07/2024.
//

import Foundation
import Alamofire

struct GetSettingsTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String = "/settings/1"
}
