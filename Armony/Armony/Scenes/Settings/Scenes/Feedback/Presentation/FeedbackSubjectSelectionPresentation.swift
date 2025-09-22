//
//  FeedbackSubjectSelectionPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 23.07.22.
//

import Foundation

protocol FeedbackSubjectSelectionDelegate: AnyObject {
    func feedbackSubjectDidSelect(subject: SelectionInput?)
}

// MARK: - FeedbackSubjectSelectionPresentation
struct FeedbackSubjectSelectionPresentation: SelectionPresentation {

    typealias Input = FeedbackSubjectSelectionInput
    typealias Output = SingleSelectionOutput<FeedbackSubjectSelectionInput>

    weak var delegate: FeedbackSubjectSelectionDelegate?
    var headerTitle: String = String(localized: "Feedback.SubjectSelection.Header.Title", table: "Feedback+Localizable")
    var isMultipleSelectionAllowed: Bool = false

    var items: [FeedbackSubjectSelectionInput]

    func continueButtonTapped() {
        delegate?.feedbackSubjectDidSelect(subject: output.output)
    }
}

// MARK: - FeedbackSubjectSelectionInput
final class FeedbackSubjectSelectionInput: SelectionInput {
    var id: Int
    var title: String
    var isSelected: Bool

    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = id.backendLocalizedText(table: .feedbackTopics)
        self.isSelected = isSelected
    }
}
