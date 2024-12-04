//
//  UserMediasPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 14.10.2023.
//

import Foundation

struct UserMediasPresentation {
    var medias: [MediaItemPresentation]

    init(medias: [MediaItem]) {
        self.medias = medias.map { MediaItemPresentation(id: $0.id, videoID: $0.videoID, url: $0.link) }
    }

    static let empty = UserMediasPresentation(medias: .empty)
}

struct MediaItemPresentation {
    let id: Int
    let videoID: String
    let url: URL

    init(id: Int, videoID: String, url: URL) {
        self.id = id
        self.videoID = videoID
        self.url = url
    }
}
