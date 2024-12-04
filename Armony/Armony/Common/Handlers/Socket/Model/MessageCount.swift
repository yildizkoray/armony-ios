//
//  MessageCount.swift
//  Armony
//
//  Created by Koray Yildiz on 15.07.23.
//

import Foundation

struct MessageCount: Decodable {
    var count: Int

    static let empty = MessageCount(count: .zero)
}
