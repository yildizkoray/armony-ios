//
//  SelectionOutput.swift
//  Armony
//
//  Created by Koray Yildiz on 24.07.22.
//

import Foundation

protocol SelectionOutput {
    associatedtype Item

    var output: Item? { get }
}

struct SingleSelectionOutput<T: SelectionInput>: SelectionOutput {
    typealias Item = T

    var output: Item?
}

struct MultipleSelectionOutput<T: SelectionInput>: SelectionOutput {
    typealias Item = [T]

    var output: Item?
}
