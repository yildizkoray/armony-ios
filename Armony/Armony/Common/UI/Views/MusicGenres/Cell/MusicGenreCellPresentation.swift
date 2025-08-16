//
//  File.swift
//  Armony
//
//  Created by Koray Yıldız on 24.01.2022.
//

import UIKit

struct MusicGenreCellPresentation {
    let borderColor: UIColor
    let borderWidth: CGFloat
    let item: MusicGenreItemPresentation
}

// MARK: - MusicGenreItemPresentation
struct MusicGenreItemPresentation {
    let id: Int
    let title: NSAttributedString

    init(genre: MusicGenre, titleStyle: TextAppearancePresentation) {
        self.id = genre.id
        let localizedTitle = genre.id.backendLocalizedText(table: .genres)
        self.title = localizedTitle.attributed(titleStyle.color, font: titleStyle.font)
    }

    init(service: ServiceResponse, titleStyle: TextAppearancePresentation) {
        self.id = service.id
        let localizedTitle = service.id.backendLocalizedText(table: .serviceTypes)
        self.title = localizedTitle.attributed(titleStyle.color, font: titleStyle.font)
    }

    init(skill: Skill, titleStyle: TextAppearancePresentation) {
        self.id = skill.id
        let localizedTitle = skill.id.backendLocalizedText(table: .serviceTypes)
        self.title = localizedTitle.attributed(titleStyle.color, font: titleStyle.font)
    }
}
