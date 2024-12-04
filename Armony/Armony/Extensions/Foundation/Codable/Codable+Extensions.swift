//
//  Codable+Extensions.swift
//  Armony
//
//  Created by Koray Yildiz on 05.06.22.
//

import Foundation

public extension Encodable {

    func body() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}
