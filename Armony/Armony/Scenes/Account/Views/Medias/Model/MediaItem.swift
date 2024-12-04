//
//  MediaItem.swift
//  Armony
//
//  Created by Koray Yıldız on 14.10.2023.
//

import Foundation

enum MediaType: String, Codable {
    case youtube
    case mp3
    case spotify
    case soundcloud
}

struct MediaItem: Decodable {
    let id: Int
    let videoID: String
    let link: URL
    let type: String
}

struct PostMediaItemRequest: Codable {
    let link: String
    let type: String
}
