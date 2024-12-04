//
//  Error+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 9.02.2022.
//

import Foundation

public extension Error {

    var api: APIError? {
        return self as? APIError
    }

    var ns: NSError {
        return self as NSError
    }
}
