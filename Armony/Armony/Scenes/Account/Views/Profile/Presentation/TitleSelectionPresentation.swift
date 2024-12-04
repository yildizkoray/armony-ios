//
//  TitleSelectionPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 23.07.22.
//

import Foundation

protocol TitleSelectionDelegate: AnyObject {
    func titleDidSelect(title: SelectionInput?)
}

struct TitleSelectionPresentation: SelectionPresentation {

    typealias Input = TitleSelectionInput
    typealias Output = SingleSelectionOutput<TitleSelectionInput>

    weak var delegate: TitleSelectionDelegate?
    var items: [TitleSelectionInput]

    var headerTitle: String = String("ProfileType", table: .common)
    var isMultipleSelectionAllowed: Bool = false

    func continueButtonTapped() {
        delegate?.titleDidSelect(title: output.output)
    }
}

// MARK: - TitleSelectionInput
final class TitleSelectionInput: SelectionInput {
    var id: Int
    var title: String
    var isSelected: Bool

    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}
