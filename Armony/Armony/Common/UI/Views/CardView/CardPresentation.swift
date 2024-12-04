//
//  CardPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 23.12.22.
//

import Foundation

public struct CardPresentation: Identifiable, Hashable {

    public let id: Int
    public let colorCode: String
    public let isActive: Bool
    public let status: Advert.Status
    public let userSummaryPresentation : UserSummaryPresentation
    public let skillsPresentation: SkillsPresentation
    public let genrePresentation: MusicGenresPresentation?

    public init(id: Int,
                colorCode: String,
                isActive: Bool,
                status: Advert.Status,
                userSummaryPresentation: UserSummaryPresentation,
                skillsPresentation: SkillsPresentation,
                genrePresentation: MusicGenresPresentation? = nil) {
        self.id = id
        self.colorCode = colorCode
        self.isActive = isActive
        self.status = status
        self.userSummaryPresentation = userSummaryPresentation
        self.skillsPresentation = skillsPresentation
        self.genrePresentation = genrePresentation
    }

    public init(advert: Advert) {
        id = advert.id
        colorCode = advert.type.colorCode
        isActive = advert.isActive
        status = advert.status

        let avatarPresentation = AvatarPresentation(
            kind: .custom(.init(size: .custom(72), radius: .medium)),
            source: .url(advert.user.avatarURL)
        )
        userSummaryPresentation = UserSummaryPresentation(
            avatarPresentation: avatarPresentation,
            name: advert.user.name.attributed(color: .white, font: .regularBody),
            location: advert.location.title.attributed(color: .white, font: .regularBody), 
            cardTitle: advert.type.title.attributed(.armonyWhite, font: .semiboldHeading), 
            updateDate: nil
        )

        skillsPresentation = SkillsPresentation(
            type: .adverts(imageViewContainerBackgroundColor: colorCode.colorFromHEX),
            title: advert.type.skillTitle.attributed(color: .white, font: .lightBody),
            skillTitleStyle: TextAppearancePresentation(color: .white, font: .regularBody),
            skills: advert.skills
        )

        if  ![1,2].contains(advert.type.id)  {
            let items = advert.skills.map { item in
                return MusicGenreItemPresentation(
                    genre: .init(id: item.id, name: item.title),
                    titleStyle: TextAppearancePresentation(color: .white, font: .regularBody)
                )
            }
            genrePresentation = MusicGenresPresentation(
                title: advert.type.skillTitle.attributed(color: .white, font: .lightBody),
                cellBorderColor: advert.type.colorCode.colorFromHEX, separator: .separator, items: items,
                shouldAdjustCellHeight: true)
        }
        else {
            genrePresentation = nil
        }
    }

    public static func == (lhs: CardPresentation, rhs: CardPresentation) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: - EMPTY
    static let empty = CardPresentation(id: .invalid,
                                        colorCode: .empty,
                                        isActive: false,
                                        status: .inactive,
                                        userSummaryPresentation: .empty(),
                                        skillsPresentation: .empty)
}
