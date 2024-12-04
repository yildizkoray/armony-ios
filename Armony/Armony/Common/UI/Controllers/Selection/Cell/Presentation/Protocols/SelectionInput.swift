//
//  SelectionInput.swift
//  Armony
//
//  Created by Koray Yildiz on 03.06.22.
//

import Foundation

protocol SelectionInput {
    var id: Int { get }
    var isSelected: Bool { get set }
    var title: String { get }
}

// MARK: - EmptySelectionInput
final class EmptySelectionInput: SelectionInput {
    var id: Int
    var title: String
    var isSelected: Bool

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
extension Array where Element == SelectionInput {
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
