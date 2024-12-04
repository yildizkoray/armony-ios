//
//  RestResponse.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

protocol RestResponse: APIResponse {

    associatedtype Data

    var data: Data { get }
    var metadata: RestResponseMeta? { get }
}

struct RestResponseMeta: Codable {
    let page: Int
    let hasNext: Bool
}
