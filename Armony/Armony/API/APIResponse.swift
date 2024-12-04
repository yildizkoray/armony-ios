//
//  APIResponse.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

protocol APIResponse: Decodable {
    
    var error: APIError? { get }
    var isSuccess: Bool { get }
}

extension APIResponse {

    var isSuccess: Bool {
        error.isNil
    }

    func throwErrorIfFailure() throws {
        if !isSuccess {
            FirebaseCrashlyticsLogger.shared.log(error: error)
            throw error!
        }
    }
}
