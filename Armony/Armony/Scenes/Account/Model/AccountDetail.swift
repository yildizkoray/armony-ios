//
//  AccountDetail.swift
//  Armony
//
//  Created by Koray Yildiz on 31.05.22.
//

import Foundation

struct UserDetail: Decodable {
    let id: String
    let name: String
    let bio: String?
    let location: Location?
    private let avatarURLString: String?
    let genres: [MusicGenre]
    let title: Title?
    let skills: [Skill]

    var avatarURL: URL? {
        return avatarURLString?.url
    }

    enum CodingKeys: String, CodingKey {
        case id, name, bio, genres, skills, title
        case avatarURLString = "photoUrl"
        case location = "city"
    }

    struct Title: Codable {
        let id: Int
        let title: String

        enum CodingKeys: String, CodingKey {
            case id
            case title = "name"
        }
    }
}
