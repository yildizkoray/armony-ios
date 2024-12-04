//
//  GetFeedbackSubjectsTask.swift
//  Armony
//
//  Created by Koray Yildiz on 21.07.22.
//

import Foundation
import Alamofire

struct GetFeedbackSubjectsTask: HTTPTask {
    enum FeedbackType: Int {
        case general = 1
        case removeAdvert = 2
        case removeAccount = 3
    }
    var method: HTTPMethod = .get
    var path: String = "/feedback-topics"
    var urlQueryItems: [URLQueryItem]?

    init(with type: GetFeedbackSubjectsTask.FeedbackType? = nil) {
        if let type {
            urlQueryItems = [
                URLQueryItem(name: "feedbackTopicType", value: type.rawValue.string)
            ]
        }
    }
}

struct PostFeedbackTask: HTTPTask {
    var method: HTTPMethod = .post
    var path: String = "/feedbacks"
    var body: Parameters?

    init(request: FeedbackRequest) {
        body = request.body()
    }
}
