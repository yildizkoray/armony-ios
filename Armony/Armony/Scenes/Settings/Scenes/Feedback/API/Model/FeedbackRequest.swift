//
//  FeedbackRequest.swift
//  Armony
//
//  Created by Koray Yildiz on 21.07.22.
//

import Foundation

struct FeedbackRequest: Encodable {
    let feedbackSubject: FeedbackSubject
    let message: String

    enum CodingKeys: String, CodingKey {
        case message
        case feedbackSubject = "feedbackTopic"
    }
}
