//
//  LocationSelectionPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 23.07.22.
//

import Foundation

protocol LocationSelectionDelegate: AnyObject {
    func locationDidSelect(location: SelectionInput?)
}

struct LocationSelectionPresentation: SelectionPresentation {
    typealias Input = LocationSelectionInput
    typealias Output = SingleSelectionOutput<LocationSelectionInput>

    weak var delegate: LocationSelectionDelegate?
    var items: [LocationSelectionInput]

    var headerTitle: String = String("Location", table: .common)
    var isMultipleSelectionAllowed: Bool = false

    func continueButtonTapped() {
        delegate?.locationDidSelect(location: output.output)
    }
}

// MARK: - LocationSelectionInput
final class LocationSelectionInput: SelectionInput {
    var id: Int
    var title: String
    var isSelected: Bool

    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}
