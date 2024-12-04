//
//  PostLogoutTask.swift
//  Armony
//
//  Created by Koray Yıldız on 05.11.22.
//

import Foundation
import Alamofire

struct PostLogoutTask: HTTPTask {
    var method: HTTPMethod = .post
    var path: String = "/auth/signout"
}
