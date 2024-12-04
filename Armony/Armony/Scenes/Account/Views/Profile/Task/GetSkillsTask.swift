//
//  GetSkillsTask.swift
//  Armony
//
//  Created by Koray Yildiz on 03.06.22.
//

import Alamofire
import Foundation

struct GetSkillsTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String = "/skills"
    var urlQueryItems: [URLQueryItem]?

    init(for advertTypeID: Int = 1) {
        urlQueryItems = [
            URLQueryItem(name: "adTypeID", value: advertTypeID.string)
        ]
    }
}
