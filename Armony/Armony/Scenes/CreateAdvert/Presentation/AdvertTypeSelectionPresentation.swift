//
//  AdvertTypeSelectionPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 05.10.22.
//

import Foundation

protocol AdvertTypeSelectionDelegate: AnyObject {
    func advertTypeDidSelect(advert: SelectionInput?)
}

struct AdvertTypeSelectionPresentation: SelectionPresentation {

    typealias Input = AdvertTypeSelectionInput

    typealias Output = SingleSelectionOutput<Input>

    weak var delegate: AdvertTypeSelectionDelegate?

    var items: [AdvertTypeSelectionInput]

    var headerTitle: String = String("AdType", table: .common)

    var isMultipleSelectionAllowed: Bool = false

    func continueButtonTapped() {
        delegate?.advertTypeDidSelect(advert: output.output)
    }
}

// MARK: - AdvertTypeSelectionInput
final class AdvertTypeSelectionInput: SelectionInput {
    var id: Int
    var title: String
    var isSelected: Bool

    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}
