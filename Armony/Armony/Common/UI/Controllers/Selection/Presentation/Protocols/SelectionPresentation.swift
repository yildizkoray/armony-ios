//
//  AnyProfileSelectionPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 04.06.22.
//

import Foundation

/**
 * Protocol defining the presentation layer for selection interfaces.
 * 
 * This protocol provides a complete interface for managing selection scenarios
 * in the app, including both single and multiple selection modes. It handles
 * the presentation logic, UI configuration, and data transformation between
 * input items and output results.
 * 
 * The protocol uses generics to ensure type safety while providing flexibility
 * for different types of selectable items and output formats.
 * 
 * ## Usage Example:
 * ```swift
 * struct MySelectionPresentation: SelectionPresentation {
 *     typealias Input = MySelectableItem
 *     typealias Output = SingleSelectionOutput<MySelectableItem>
 *     
 *     var items: [Input]
 *     var headerTitle: String { return "Select an option" }
 *     var isMultipleSelectionAllowed: Bool { return false }
 *     
 *     func continueButtonTapped() {
 *         // Handle selection completion
 *     }
 * }
 * ```
 * 
 * - Generic Parameter Input: The type of selectable item (must conform to SelectionInput)
 * - Generic Parameter Output: The type of selection result (must conform to SelectionOutput)
 */
protocol SelectionPresentation {
    /// The type of input items that can be selected
    associatedtype Input: SelectionInput
    /// The type of output result from the selection
    associatedtype Output: SelectionOutput

    /// Array of all available items for selection
    var items: [Input] { get }
    /// The final selection result
    var output: Output { get }

    /// Title displayed in the selection interface header
    var headerTitle: String { get }
    /// Title for the action button (e.g., "Continue", "Done")
    var actionButtonTitle: String { get }
    /// Whether multiple items can be selected simultaneously
    var isMultipleSelectionAllowed: Bool { get }

    /// Image name for unselected items (checkbox or radio button)
    var defaultImageName: String { get }
    /// Image name for selected items (checked checkbox or radio button)
    var selectedImageName: String { get }

    /**
     * Called when the user taps the continue/action button.
     * 
     * This method should handle the completion of the selection process,
     * such as navigating to the next screen or processing the selection.
     */
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
