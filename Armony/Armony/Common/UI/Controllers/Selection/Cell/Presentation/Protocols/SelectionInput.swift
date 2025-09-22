//
//  SelectionInput.swift
//  Armony
//
//  Created by Koray Yildiz on 03.06.22.
//

import Foundation

/**
 * Protocol defining the structure for selectable items in the selection system.
 * 
 * This protocol provides a standardized interface for items that can be selected
 * in various selection scenarios throughout the app, such as:
 * - Profile selection
 * - Category selection
 * - Region selection
 * - Any other multi-choice or single-choice scenarios
 * 
 * ## Usage Example:
 * ```swift
 * struct MySelectableItem: SelectionInput {
 *     let id: Int
 *     let title: String
 *     var isSelected: Bool
 * }
 * ```
 */
protocol SelectionInput {
    /// Unique identifier for the selectable item
    var id: Int { get }
    
    /// Indicates whether this item is currently selected
    /// This property should be mutable to allow selection state changes
    var isSelected: Bool { get set }
    
    /// Display text for the item that will be shown to the user
    var title: String { get }
}

// MARK: - EmptySelectionInput

/**
 * Concrete implementation of SelectionInput for empty or placeholder selection items.
 * 
 * This class is typically used when you need to represent an "empty" or "none" option
 * in a selection interface, such as "No preference" or "Select all" options.
 * 
 * ## Usage Example:
 * ```swift
 * let emptyOption = EmptySelectionInput(
 *     id: 0,
 *     title: "No preference",
 *     isSelected: false
 * )
 * ```
 */
final class EmptySelectionInput: SelectionInput {
    /// Unique identifier for the empty selection item
    var id: Int
    
    /// Display text for the empty selection item
    var title: String
    
    /// Selection state of the empty selection item
    var isSelected: Bool

    /**
     * Image name for the empty selection item.
     * 
     * Returns an empty string, indicating no specific image should be displayed
     * for this selection item.
     */
    var imageName: String {
        return .empty
    }

    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}

// MARK: - Array + AnyProfileSelectionInput

/**
 * Extension providing utility methods for arrays of SelectionInput items.
 */
extension Array where Element == SelectionInput {
    /**
     * Creates a combined title string from multiple selection inputs.
     * 
     * This computed property joins the titles of all items in the array:
     * - If there are 2 or more items: titles are joined with ", " (comma + space)
     * - If there's only 1 item: returns the title as-is
     * 
     * ## Examples:
     * - Single item: "Apple" → "Apple"
     * - Multiple items: ["Apple", "Banana", "Cherry"] → "Apple, Banana, Cherry"
     * 
     * - Returns: A string representation of all titles combined
     */
    var title: String {
        guard count < 2 else {
            return map {
                $0.title
            }.joined(separator: .comma + .space)
        }
        return map {
            $0.title
        }.joined(separator: .empty)
    }
}
