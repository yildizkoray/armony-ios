//
//  AdvertPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 8.09.2021.
//

import Foundation

struct AdvertPresentation {
    let id: Int
    let colorCode: String
    let isActive: Bool
    let status: Advert.Status
    let titleAccessoryPresentation: TitleAccessoryPresentation
    let userSummaryPresentation: UserSummaryPresentation
    let skillsPresentation: SkillsPresentation

    init(advert: Advert) {
        id = advert.id
        colorCode = advert.type.colorCode
        isActive = advert.isActive
        status = advert.status

        titleAccessoryPresentation = TitleAccessoryPresentation(
            title: advert.type.title.attributed(.armonyWhite, font: .regularSubheading),
            accessoryImage: .static(.rightArrowIcon)
        )

        let avatarPresentation =  AvatarPresentation(kind: .custom(.init(size: .custom(72), radius: .medium)), source: .url(advert.user.avatarURL))
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
    }
}
