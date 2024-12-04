//
//  ServiceSelectionPresentation.swift
//  Armony
//
//  Created by KORAY YILDIZ on 14/06/2024.
//

import Foundation

protocol ServiceSelectionDelegate: AnyObject {
    func serviceDidSelect(services: [SelectionInput]?)
}

struct ServiceSelectionPresentation: SelectionPresentation {
    typealias Input = ServiceSelectionInput
    typealias Output = MultipleSelectionOutput<ServiceSelectionInput>

    weak var delegate: ServiceSelectionDelegate?
    var items: [ServiceSelectionInput]

    var headerTitle: String = String("LessonFormat", table: .common)
    var isMultipleSelectionAllowed: Bool = true

    func continueButtonTapped() {
        delegate?.serviceDidSelect(services: output.output)
    }
}

// MARK: - ServiceSelectionInput
final class ServiceSelectionInput: SelectionInput {
    var id: Int
    var title: String
    var isSelected: Bool

    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}
