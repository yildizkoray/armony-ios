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
}
