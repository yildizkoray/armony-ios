//
//  Socket.swift
//  Armony
//
//  Created by Koray Yıldız on 25.11.22.
//

import Foundation

struct Socket {
    struct Frame<T: Encodable>: Encodable {
        let data: T

        init(data: T) {
            self.data = data
        }

        var messsage: String {
            guard let data = try? JSONEncoder().encode(self),
                  let jsonString = String(data: data, encoding: .utf8) else {
                return .empty
            }
            return jsonString
        }
    }
}
