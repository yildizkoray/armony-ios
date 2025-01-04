//
//  Card.swift
//  Armony
//
//  Created by Koray Yıldız on 14.11.2021.
//

import Foundation

public struct Advert: Decodable {

    public enum Status: String, Decodable {
        case active = "active"
        case deleted = "deleted"
        case inactive = "inactive"
        case autoInactive = "auto_inactive"
    }

    struct Properties: Decodable {
        let id: Int
        let title: String
        let colorCode: String
        let skillTitle: String

        enum CodingKeys: String, CodingKey {
            case id
            case title = "name"
            case skillTitle
            case colorCode
        }
    }

    let id: Int
    let location: Location
    let description: String?
    let type: Advert.Properties

    @DefaultDecodable<Empty>
    var genres: [MusicGenre]

    let isActive: Bool
    
    @DefaultDecodable<Empty>
    var skills: [Skill]
    
    let user: ArmonyUser
    let status: Advert.Status
    let updateDate: String

    @DefaultDecodable<Empty>
    var serviceTypes: [ServiceResponse]

    var externalLink: URL?

    var isStatusActive: Bool {
        return status == .active
    }

    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id, description, genres, skills, user, isActive, status, serviceTypes
        case type = "adType"
        case location = "city"
        case updateDate = "updatedAt"
        case externalLink = "external_link"
    }
}
