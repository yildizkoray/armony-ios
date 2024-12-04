//
//  ServiceResponse.swift
//  Armony
//
//  Created by KORAY YILDIZ on 03/07/2024.
//

import Foundation

struct ServiceResponse: Codable {
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

    static let empty = ServiceResponse(id: .invalid, title: .empty)
}
