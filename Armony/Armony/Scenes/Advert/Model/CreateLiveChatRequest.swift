//
//  CreateLiveChatRequest.swift
//  Armony
//
//  Created by Koray Yildiz on 29.12.22.
//

import Foundation

struct CreateLiveChatRequest: Encodable {
    let advertID: Int

    enum CodingKeys: String, CodingKey {
        case advertID = "adId"
    }

    init(advertID: Int) {
        self.advertID = advertID
    }
}
