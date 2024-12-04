//
//  SkillCellPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 14.11.2021.
//

import UIKit

struct SkillCellPresentation {
    let axis: NSLayoutConstraint.Axis
    let spacing: CGFloat
    let imageViewContainerViewWidth: CGFloat
    let inset: CGFloat
    let imageContainerViewColor: UIColor
    let imageContainerViewBorderColor: UIColor?
    let imageContainerViewBorderWidth: CGFloat?
    let skill: SkillItemPresentation
}

// MARK: - SkillPresentation
struct SkillItemPresentation {
    let id: Int
    let title: NSAttributedString
    let colorCode: String
    let iconURL: URL

    init(style skillTitleStylePresentation: TextAppearancePresentation, skill: Skill) {
        id = skill.id
        title = skill.title.attributed(skillTitleStylePresentation.color, font: skillTitleStylePresentation.font)
        colorCode = skill.colorCode.ifNil(.blueColor)
        iconURL = skill.iconURL.ifNil(.localhost)
    }
}
