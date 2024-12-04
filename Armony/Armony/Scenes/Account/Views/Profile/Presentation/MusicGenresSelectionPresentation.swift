//
//  MusicGenresPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 23.07.22.
//

import Foundation

protocol MusicGenresSelectionDelegate: AnyObject {
    func musicGenresDidSelect(genres: [SelectionInput]?)
}

struct MusicGenresSelectionPresentation: SelectionPresentation {
    typealias Input = MusicGenresSelectionInput
    typealias Output = MultipleSelectionOutput<MusicGenresSelectionInput>

    weak var delegate: MusicGenresSelectionDelegate?
    var items: [MusicGenresSelectionInput]

    var headerTitle: String = String("MusicGenre", table: .common)
    var isMultipleSelectionAllowed: Bool = true

    func continueButtonTapped() {
        delegate?.musicGenresDidSelect(genres: output.output)
    }
}

// MARK: - MusicGenresSelectionInput
final class MusicGenresSelectionInput: SelectionInput {
    var id: Int
    var title: String
    var isSelected: Bool

    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}
