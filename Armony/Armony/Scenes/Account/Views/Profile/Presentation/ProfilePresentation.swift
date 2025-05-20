//
//  ProfilePresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 31.05.22.
//

import Foundation

struct ProfilePresentation {
    var bio: String?
    var avatarURLString: String?
    var title: UserDetail.Title?
    var skills: [Skill]?
    var musicGenres: [MusicGenre]?
    var location: Location?

    // MARK: - EMPTY
    static let empty = ProfilePresentation()

    func isEmpty() -> Bool {
        return title.isNil &&
        skills.ifNil(.empty).isEmpty &&
        musicGenres.ifNil(.empty).isEmpty &&
        location.ifNil(.empty).title.isEmpty
    }
}

extension ProfilePresentation {
    func eventParameters() -> [String: String] {
        return [
            "bio": bio.emptyIfNil,
            "skills": skills.ifNil(.empty).map { $0.title }.joined(separator: .comma),
            "music_genre": musicGenres.ifNil(.empty).map { $0.name }.joined(separator: .comma),
            "location": location?.title ?? .empty,
            "title": title?.title ?? .empty
        ]
    }
}
