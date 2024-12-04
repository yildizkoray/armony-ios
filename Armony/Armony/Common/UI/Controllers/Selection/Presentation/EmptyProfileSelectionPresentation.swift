//
//  EmptyProfileSelectionPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 23.07.22.
//

import Foundation

struct EmptyProfileSelectionPresentation: SelectionPresentation {
    var actionButtonTitle: String = .empty

    var items: [EmptySelectionInput] = .empty

    var output: SingleSelectionOutput<EmptySelectionInput> {
        return .init()
    }

    var headerTitle: String = .empty

    var isMultipleSelectionAllowed: Bool = false

    func continueButtonTapped() {

    }

    typealias Input = EmptySelectionInput

    typealias Output = SingleSelectionOutput<EmptySelectionInput>
}
