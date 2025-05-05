//
//  Skill.swift
//  Armony
//
//  Created by Koray Yıldız on 8.10.2021.
//

import UIKit

struct Skill: Codable, Hashable {
    let id: Int
    let iconURL: URL?
    let title: String
    let colorCode: String?

    enum CodingKeys: String, CodingKey {
        case id
        case iconURL = "imageUrl"
        case title = "name"
        case colorCode
    }

    init(id: Int, iconURL: URL?, title: String, colorCode: String?) {
        self.id = id
        self.iconURL = iconURL
        self.title = title
        self.colorCode = colorCode
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        do {
            self.iconURL = try container.decodeIfPresent(URL.self, forKey: .iconURL)
        } catch {
            self.iconURL = nil
        }
        self.title = try container.decode(String.self, forKey: .title)
        self.colorCode = try container.decodeIfPresent(String.self, forKey: .colorCode)
    }
}

// MARK: - Location
extension RestArrayResponse where T == Location {

    func itemsForSelection(selectedID: Int?) -> [LocationSelectionInput] {
        let items: [LocationSelectionInput] = data.compactMap { location in
            return LocationSelectionInput(
                id: location.id,
                title: location.title,
                isSelected: selectedID == location.id
            )
        }
        return items
    }
}

// MARK: - Skill
extension RestArrayResponse where T == Skill {

    func itemsForSelection(selectedIDs: [Int]) -> [SkillsSelectionInput] {
        let items: [SkillsSelectionInput] = data.compactMap { skill in
            return SkillsSelectionInput(
                id: skill.id,
                title: skill.title,
                isSelected: selectedIDs.contains(skill.id)
            )
        }
        return items
    }
}

// MARK: - AdvertType
extension RestArrayResponse where T == Advert.Properties {

    func itemsForSelection(selectedID: Int?) -> [AdvertTypeSelectionInput] {
        let items: [AdvertTypeSelectionInput] = data.compactMap { advertType in
            return AdvertTypeSelectionInput(
                id: advertType.id,
                title: advertType.title,
                isSelected: selectedID == advertType.id
            )
        }
        return items
    }
}

// MARK: - MusicGenre
extension RestArrayResponse where T == MusicGenre {

    func itemsForSelection(selectedIDs: [Int]) -> [MusicGenresSelectionInput] {
        let items: [MusicGenresSelectionInput] = data.compactMap { advertType in
            return MusicGenresSelectionInput(
                id: advertType.id,
                title: advertType.name,
                isSelected: selectedIDs.contains(advertType.id)
            )
        }
        return items
    }
}

// MARK: - ServiceResponse
extension RestArrayResponse where T == ServiceResponse {

    func itemsForSelection(selectedIDs: [Int]) -> [ServiceSelectionInput] {
        let items: [ServiceSelectionInput] = data.compactMap { service in
            return ServiceSelectionInput(
                id: service.id,
                title: service.title,
                isSelected: selectedIDs.contains(service.id)
            )
        }
        return items
    }
}
