//
//  DropdownPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 05.10.22.
//

import Foundation

struct DropdownPresentation {
    let title: String
    let placeholder: String

    init(title: String, placeholder: String) {
        self.title = title
        self.placeholder = placeholder
    }

    init(title: String) {
        self.init(title: title, placeholder: title)
    }

    // MARK: - EMPTY
    static let empty = DropdownPresentation(title: .empty, placeholder: .empty)

    static let title = DropdownPresentation(title: String("ProfileType",table: .common))
    static let skill = DropdownPresentation(title: String("InstrumentsSkill",table: .common))
    static let musicGenres = DropdownPresentation(title: String("MusicGenre",table: .common))
    static let location = DropdownPresentation(title: String("Location",table: .common))

    static let feedback = DropdownPresentation(
        title: "Subject",
        placeholder: "Subject"
    )
    static let advertType = DropdownPresentation(title: String("AdType",table: .common))

    static let services = DropdownPresentation(title: String("Services",table: .common))
    static let instruction = DropdownPresentation(title: String("Lessons",table: .common))
    static let instructionType = DropdownPresentation(title: String("LessonFormat",table: .common))
}
