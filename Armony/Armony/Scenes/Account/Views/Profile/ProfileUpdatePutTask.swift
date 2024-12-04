//
//  PutProfileTask.swift
//  Armony
//
//  Created by Koray Yildiz on 04.06.22.
//

import Alamofire
import Foundation

struct PutProfileTask: HTTPTask {
    var method: HTTPMethod = .put
    var path: String
    var body: Parameters?

    init(userID: String, request: PutProfileUpdateRequest) {
        path = "/users/\(userID)"
        body = request.body()
    }
}

struct PutProfileUpdateRequest: Encodable {

    var bio: String?
    var location: Location?
    var genres: [MusicGenre]?
    var title: UserDetail.Title?
    var skills: [Skill]?

    init(bio: String? = nil,
         city: Location? = nil,
         genres: [MusicGenre]? = nil,
         title: UserDetail.Title? = nil,
         skills: [Skill]? = nil) {
        self.bio = bio
        self.location = city
        self.genres = genres
        self.title = title
        self.skills = skills
    }

    enum CodingKeys: String, CodingKey {
        case bio
        case location = "city"
        case genres
        case title
        case skills
    }

    // MARK: - EMPTY
    static let empty = PutProfileUpdateRequest()
}
