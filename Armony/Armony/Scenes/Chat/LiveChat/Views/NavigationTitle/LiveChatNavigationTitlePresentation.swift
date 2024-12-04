//
//  LiveChatNavigationTitlePresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 24.12.22.
//

import Foundation

struct LiveChatNavigationTitlePresentation {
    let avatarURL: URL?
    let name: String

    init(avatarURL: URL?, name: String) {
        self.avatarURL = avatarURL
        self.name = name
    }
}
