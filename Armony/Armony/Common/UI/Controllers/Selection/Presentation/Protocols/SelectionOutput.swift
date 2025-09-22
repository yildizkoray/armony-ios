//
//  SelectionOutput.swift
//  Armony
//
//  Created by Koray Yildiz on 24.07.22.
//

import Foundation

/**
 * Protocol defining the output structure for selection operations.
 * 
 * This protocol provides a standardized way to represent the result of selection
 * operations, whether they involve single or multiple item selection. It uses
 * generics to ensure type safety while maintaining flexibility.
 * 
 * The protocol is designed to work with the SelectionInput protocol to create
 * a complete selection system that can handle various selection scenarios.
 * 
 * ## Usage Example:
 * ```swift
 * struct MySelectionOutput: SelectionOutput {
 *     typealias Item = MySelectableItem
 *     var output: Item?
 * }
 * ```
 */
protocol SelectionOutput {
    /// The type of item that can be selected
    associatedtype Item

    /**
     * The selected item(s) as the result of a selection operation.
     * 
     * This property contains the final selection result:
     * - For single selection: contains one item or nil if nothing is selected
     * - For multiple selection: contains an array of items or nil if nothing is selected
     */
    var output: Item? { get }
}

/**
 * Output structure for single item selection scenarios.
 * 
 * This struct is used when only one item can be selected at a time,
 * such as choosing a single category, region, or preference.
 * 
 * ## Usage Example:
 * ```swift
 * let singleOutput = SingleSelectionOutput<MySelectableItem>(output: selectedItem)
 * if let selected = singleOutput.output {
 *     print("Selected: \(selected.title)")
 * }
 * ```
 * 
 * - Generic Parameter T: The type of selectable item (must conform to SelectionInput)
 */
struct SingleSelectionOutput<T: SelectionInput>: SelectionOutput {
    /// The type of item that can be selected
    typealias Item = T

    /**
     * The single selected item.
     * 
     * - Returns: The selected item if one is selected, nil otherwise
     */
    var output: Item?
}

/**
 * Output structure for multiple item selection scenarios.
 * 
 * This struct is used when multiple items can be selected simultaneously,
 * such as choosing multiple categories, tags, or preferences.
 * 
 * ## Usage Example:
 * ```swift
 * let multipleOutput = MultipleSelectionOutput<MySelectableItem>(output: selectedItems)
 * if let selected = multipleOutput.output {
 *     print("Selected \(selected.count) items")
 * }
 * ```
 * 
 * - Generic Parameter T: The type of selectable item (must conform to SelectionInput)
 */
struct MultipleSelectionOutput<T: SelectionInput>: SelectionOutput {
    /// The type of item that can be selected (array of items)
    typealias Item = [T]

    /**
     * The array of selected items.
     * 
     * - Returns: Array of selected items if any are selected, nil otherwise
     */
    var output: Item?
}
