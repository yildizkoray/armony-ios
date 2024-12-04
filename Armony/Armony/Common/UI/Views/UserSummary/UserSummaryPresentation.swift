//
//  UserSummary.swift
//  Armony
//
//  Created by Koray Yıldız on 8.09.2021.
//

import UIKit

public struct UserSummaryPresentation {

    let avatarPresentation: AvatarPresentation
    let shouldShowDotsButton: Bool
    let location: NSAttributedString?
    let name: NSAttributedString
    let title: NSAttributedString?
    let cardTitle: NSAttributedString?
    let updateDate: NSAttributedString?

    init(avatarPresentation: AvatarPresentation,
         shouldShowDotsButton: Bool = false,
         name: NSAttributedString,
         title: NSAttributedString? = nil,
         location: NSAttributedString?,
         cardTitle: NSAttributedString?,
         updateDate: NSAttributedString? = nil) {
        self.avatarPresentation = avatarPresentation
        self.shouldShowDotsButton = shouldShowDotsButton
        self.name = name
        self.title = title
        self.location = location
        self.cardTitle = cardTitle
        self.updateDate = updateDate
    }

    static func empty(avatarSize: AvatarPresentation.Kind = .custom(.init(size: .medium))) -> UserSummaryPresentation {
        return UserSummaryPresentation(
            avatarPresentation: .empty,
            name: .empty,
            title: .empty,
            location: .empty, 
            cardTitle: .empty, 
            updateDate: .empty
        )
    }
}
