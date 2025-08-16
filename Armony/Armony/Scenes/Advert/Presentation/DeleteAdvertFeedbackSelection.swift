//
//  DeleteAdvertFeedbackSelection.swift
//  Armony
//
//  Created by Koray Yıldız on 9.12.2023.
//

import Foundation

protocol DeleteAdvertFeedbackSelectionDelegate: AnyObject {
    func deleteAdvertFeedbackDidSelect(output: DeleteAdvertFeedbackSelectionInput?)
}

struct DeleteAdvertFeedbackSelection: SelectionPresentation {
    typealias Input = DeleteAdvertFeedbackSelectionInput
    typealias Output = SingleSelectionOutput<DeleteAdvertFeedbackSelectionInput>

    var items: [DeleteAdvertFeedbackSelectionInput]
    var headerTitle: String = "Why do you want to delete your ad?"
    var isMultipleSelectionAllowed: Bool = false
    weak var delegate: DeleteAdvertFeedbackSelectionDelegate?

    func continueButtonTapped() {
        delegate?.deleteAdvertFeedbackDidSelect(output: output.output)
    }
}

final class DeleteAdvertFeedbackSelectionInput: SelectionInput {
    var id: Int
    var isSelected: Bool
    var title: String

    init(id: Int, isSelected: Bool, title: String) {
        self.id = id
        self.isSelected = isSelected
        self.title = id.backendLocalizedText(table: .feedbackTopics)
    }
}
