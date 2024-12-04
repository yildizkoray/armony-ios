//
//  Location.swift
//  Armony
//
//  Created by Koray Yildiz on 03.06.22.
//

import Foundation

struct Location: Codable {
    let id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
    }

    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }

    static let empty = Location(id: .invalid, title: .empty)
}

