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
        self.title = genre.name.attributed(titleStyle.color, font: titleStyle.font)
    }

    init(genre: ServiceResponse, titleStyle: TextAppearancePresentation) {
        self.id = genre.id
        self.title = genre.title.attributed(titleStyle.color, font: titleStyle.font)
    }

    init(genre: Skill, titleStyle: TextAppearancePresentation) {
        self.id = genre.id
        self.title = genre.title.attributed(titleStyle.color, font: titleStyle.font)
    }
}
