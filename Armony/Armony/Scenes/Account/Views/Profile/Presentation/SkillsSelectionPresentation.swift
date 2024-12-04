//
//  SkillsSelectionPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 23.07.22.
//

import Foundation

protocol SkillsSelectionDelegate: AnyObject {
    func skillsDidSelect(skills: [SelectionInput]?)
}

struct SkillsSelectionPresentation: SelectionPresentation {

    typealias Input = SkillsSelectionInput
    typealias Output = MultipleSelectionOutput<SkillsSelectionInput>

    weak var delegate: SkillsSelectionDelegate?
    var items: [SkillsSelectionInput]

    var headerTitle: String = String("InstrumentsSkill", table: .common)
    var isMultipleSelectionAllowed: Bool = true

    func continueButtonTapped() {
        delegate?.skillsDidSelect(skills: output.output)
    }
}

// MARK: - SkillsSelectionInput
final class SkillsSelectionInput: SelectionInput {
    var id: Int
    var title: String
    var isSelected: Bool

    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}
