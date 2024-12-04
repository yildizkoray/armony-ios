//
//  PutAvatarUpdateTask.swift
//  Armony
//
//  Created by Koray Yıldız on 03.11.22.
//

import Foundation
import Alamofire

struct PutAvatarUpdateTask: HTTPUploadTask {
    var method: HTTPMethod = .put
    var path: String
    var files: [FormData]

    init(userID: String, file: FormData) {
        files = [file]
        path = "/users/\(userID)/photo"
    }
}
