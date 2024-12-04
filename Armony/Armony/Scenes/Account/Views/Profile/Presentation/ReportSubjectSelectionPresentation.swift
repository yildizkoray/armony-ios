//
//  ReportSubjectSelectionPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 18.05.23.
//

import Foundation

protocol ReportSubjectSelectionDelegate: AnyObject {
    func reportSubjectDidSelect(subject: SelectionInput?)
}

struct ReportSubjectSelectionPresentation: SelectionPresentation {
    typealias Input = ReportSubjectSelectionInput
    typealias Output = SingleSelectionOutput<ReportSubjectSelectionInput>

    weak var delegate: ReportSubjectSelectionDelegate?
    var items: [ReportSubjectSelectionInput]

    var headerTitle: String = String("ReportReason", table: .common)
    var isMultipleSelectionAllowed: Bool = false

    func continueButtonTapped() {
        delegate?.reportSubjectDidSelect(subject: output.output)
    }
}

// MARK: - ReportSubjectSelectionInput
final class ReportSubjectSelectionInput: SelectionInput {
    var id: Int
    var title: String
    var isSelected: Bool

    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}
