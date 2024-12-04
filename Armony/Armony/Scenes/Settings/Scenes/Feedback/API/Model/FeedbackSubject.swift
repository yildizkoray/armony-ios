//
//  FeedbackSubject.swift
//  Armony
//
//  Created by Koray Yildiz on 17.07.22.
//

import Foundation

struct FeedbackSubject: Codable {
    let id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
    }
}
