//
//  RestObjectResponse.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

struct RestObjectResponse<T: Decodable>: RestResponse {
    
    typealias Data = T

    var data: Data
    var metadata: RestResponseMeta?
    var error: APIError?
}
