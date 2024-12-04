//
//  AnySelectionPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 24.07.22.
//

import Foundation

final class AnySelectionPresentation {
    private(set) var items: [SelectionInput]

    private(set) var headerTitle: String

    private(set) var isMultipleSelectionAllowed: Bool

    var selectedItems: [SelectionInput] {
        return items.filter { $0.isSelected }
    }

    var selectedItemIDs: [Int]? {
        return selectedItems.compactMap { $0.id }
    }

    private var continueButtonTappedClosure: () -> Void

    func continueButtonTapped() {
        continueButtonTappedClosure()
    }

    init<Presentation: SelectionPresentation>(presentation: Presentation) {
        self.items = presentation.items.sorted { $0.isSelected && !$1.isSelected }
        self.headerTitle = presentation.headerTitle
        self.isMultipleSelectionAllowed = presentation.isMultipleSelectionAllowed
        continueButtonTappedClosure = presentation.continueButtonTapped
    }

    // MARK: - EMPTY
    static let empty = AnySelectionPresentation(presentation: EmptyProfileSelectionPresentation())
}
