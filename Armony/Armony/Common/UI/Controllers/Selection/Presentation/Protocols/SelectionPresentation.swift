//
//  AnyProfileSelectionPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 04.06.22.
//

import Foundation

protocol SelectionPresentation {
    associatedtype Input: SelectionInput
    associatedtype Output: SelectionOutput

    var items: [Input] { get }
    var output: Output { get }

    var headerTitle: String { get }
    var actionButtonTitle: String { get }
    var isMultipleSelectionAllowed: Bool { get }

    var defaultImageName: String { get }
    var selectedImageName: String { get }

    func continueButtonTapped()
}

// MARK: - SelectionPresentation
extension SelectionPresentation {
    var selectedItems: [SelectionInput] {
        return items.filter { $0.isSelected }
    }

    var selectedItemIDs: [Int]? {
        return selectedItems.compactMap { $0.id }
    }

    var actionButtonTitle: String {
        return String(localized: "Common.Continue", table: "Common+Localizable")
    }

    var defaultImageName: String {
        if isMultipleSelectionAllowed {
            return "checkbox-default-icon"
        }
        return "radio-button-default-icon"
    }

    var selectedImageName: String {
        if isMultipleSelectionAllowed {
            return "checkbox-selected-icon"
        }
        return "radio-button-selected-icon"
    }
}

extension SelectionPresentation where Output == MultipleSelectionOutput<Input> {
    var output: Output {
        return items.outputs
    }
}

extension SelectionPresentation where Output == SingleSelectionOutput<Input> {
    var output: Output {
        return items.output
    }
}

// MARK: - SelectionPresentation + Outputs
private extension Array where Element: SelectionInput {
    var output: SingleSelectionOutput<Element> {
        return .init(output: first { $0.isSelected })
    }

    var outputs: MultipleSelectionOutput<Element> {
        return .init(output: filter { $0.isSelected })
    }
}




