//
//  FeedbacksPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 17.07.22.
//

import Foundation

struct FeedbacksPresentation {
    let subjects: [FeedbackSubjectPresentation]

    init(data: [FeedbackSubject]) {
        subjects = data.compactMap {
            FeedbackSubjectPresentation(id: $0.id, title: $0.title)
        }
    }

    // MARK: - EMPTY
    static let empty = FeedbacksPresentation(data: .empty)
}
