//
//  RestErrorResponse.swift
//  Armony
//
//  Created by Koray Yıldız on 7.09.2021.
//

import Foundation

public struct RestErrorResponse: APIResponse {
    var error: APIError?
}
