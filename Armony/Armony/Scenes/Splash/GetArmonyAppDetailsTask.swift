//
//  GetArmonyAppDetailsTask.swift
//  Armony
//
//  Created by Koray Yıldız on 12.12.2023.
//

import Foundation
import Alamofire

struct GetArmonyAppDetailsTask: HTTPTask {
    var method: HTTPMethod = .get
    var path: String = "lookup"
    var host: String = "itunes.apple.com"
    var urlQueryItems: [URLQueryItem]?
    var apiVersion: String = .empty

    init() {
        urlQueryItems = [
            URLQueryItem(name: "bundleId", value: "com.armonyapp.armony"),
            URLQueryItem(name: "country", value: "tr")
        ]
    }
}

struct ArmonyAppStoreDetail: APIResponse {
    struct Detail: Decodable {
        let version: String
    }

    private let details: [Detail]
    var error: APIError?
    var version: String? {
        return details.first?.version
    }

    enum CodingKeys: String, CodingKey {
        case details = "results"
        case error = "error"
    }
}

final class ForceUpdateHandler {
    private let restService: RestService = .init(backend: .factory())

    func shouldUpdate() async throws -> Bool {
        do {
            let response = try await restService.execute(
                task: GetArmonyAppDetailsTask(),
                type: ArmonyAppStoreDetail.self
            )
            let appVersion = Bundle.main.version
            let storeVersion = response.version ?? .empty

            if storeVersion.compare(appVersion, options: .numeric) == .orderedDescending {
                return true
            }
            return false
        }
    }
}
