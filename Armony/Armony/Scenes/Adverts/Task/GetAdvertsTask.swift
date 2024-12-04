//
//  GetAdvertsTask.swift
//  Armony
//
//  Created by Koray Yıldız on 14.11.2021.
//

import Alamofire
import Foundation

struct GetAdvertsTask: HTTPTask, PaginatableTask {
    var page: Int

    var method: HTTPMethod = .get
    var path: String = "/ads"

    public var urlQueryItems: [URLQueryItem]? {
        var items = queryItems
        items.append(URLQueryItem(name: "page", value: page.string))
        return items
    }

    private var queryItems: [URLQueryItem]

    init(userID: String, adTypeIDs: String? = nil, cityIDs: String? = nil) {
        queryItems = [
            URLQueryItem(name: "userID", value: userID),

        ]

        if let adTypeIDs {
            queryItems.append(
                URLQueryItem(name: "adTypeIDs", value: adTypeIDs)
            )
        }

        if let cityIDs {
            queryItems.append(
                URLQueryItem(name: "cityIDs", value: cityIDs)
            )
        }

        page = 1
    }
}
