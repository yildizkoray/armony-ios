//
//  ReportSubject.swift
//  Armony
//
//  Created by Koray Yildiz on 23.05.23.
//

import Foundation

struct ReportSubject: Codable {
    let id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "name"
    }
}

struct PostReportSubjectRequest: Codable {
    let reportedAdId: Int
    let reportedUserId: String
    let reportTopicId: Int
}

struct PostBlockUserRequest: Codable {
    let blockedUserId: String
}
