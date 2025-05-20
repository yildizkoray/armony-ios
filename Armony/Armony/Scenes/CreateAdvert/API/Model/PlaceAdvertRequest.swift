//
//  PlaceAdvertRequest.swift
//  Armony
//
//  Created by Koray Yıldız on 06.10.22.
//

import Foundation

struct PlaceAdvertRequest: Encodable {
    var advertTypeID: Int
    var skills: [Skill]?
    var location: Location?
    var genres: [MusicGenre]?
    var description: String?
    var serviceTypes: [ServiceResponse]?

    init(advertTypeID: Int,
         city: Location,
         genres: [MusicGenre],
         skills: [Skill],
         description: String?,
         serviceTypes: [ServiceResponse]?) {
        self.advertTypeID = advertTypeID
        self.location = city
        self.genres = genres
        self.skills = skills
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case advertTypeID = "adTypeId"
        case location = "city"
        case skills, genres, description
        case serviceTypes
    }

    // MARK: - EMPTY
    static let empty = PlaceAdvertRequest(
        advertTypeID: .invalid,
        city: .empty,
        genres: .empty,
        skills: .empty,
        description: nil, 
        serviceTypes: .empty
    )
}


extension PlaceAdvertRequest {
    func eventParameters() -> [String: String] {
        return [
            "skills": skills.ifNil(.empty).compactMap { $0.title }.joined(separator: .comma),
            "music_genre": genres.ifNil(.empty).compactMap { $0.name }.joined(separator: .comma),
            "lesson_format": serviceTypes.ifNil(.empty).compactMap { $0.title }.joined(separator: .comma),
            "location": location.ifNil(.empty).title,
            "description": description.ifNil(.empty)
        ]
    }
}
