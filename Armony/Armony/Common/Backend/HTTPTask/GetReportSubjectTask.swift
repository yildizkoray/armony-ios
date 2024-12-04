//
//  GetReportSubjectTask.swift
//  Armony
//
//  Created by Koray Yildiz on 23.05.23.
//

import Alamofire
import Foundation

struct GetReportSubjectTask: HTTPTask {
    enum Params: String {
        case ad = "ad"
        case user = "user"
    }
    var method: HTTPMethod = .get
    var path: String = "/report-topics"
    var urlQueryItems: [URLQueryItem]?

    init(with param: GetReportSubjectTask.Params) {
        urlQueryItems = [
            URLQueryItem(name: "reportType", value: param.rawValue)
        ]
    }
}

struct PostReportSubjectTask: HTTPTask {
    enum Params: String {
        case ad = "ad"
        case user = "user"
    }
    var method: HTTPMethod = .post
    var path: String = "/reports"
    var urlQueryItems: [URLQueryItem]?
    var body: Parameters?

    init(with param: GetReportSubjectTask.Params, request: PostReportSubjectRequest) {
        urlQueryItems = [
            URLQueryItem(name: "reportType", value: param.rawValue)
        ]
        body = request.body()
    }
}

struct PostBlockUserTask: HTTPTask {
    var method: HTTPMethod = .post
    var path: String
    var body: Parameters?

    init(userID: String, request: PostBlockUserRequest) {
        path = "/users/\(userID)/block"
        body = request.body()
    }
}
