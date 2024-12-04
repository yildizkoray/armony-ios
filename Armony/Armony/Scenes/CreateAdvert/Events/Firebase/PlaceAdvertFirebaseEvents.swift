//
//  PlaceAdvertFirebaseEvents.swift
//  Armony
//
//  Created by Koray Yıldız on 23.12.2023.
//

import Foundation

struct PlaceAdvertFirebaseEvents: FirebaseEvent {
    var category: String = "Card"
    var action: String = "Complete"
    var parameters: Payload

    let skills: String
    let musicGenres: String
    let location: String
    let explanation: String

    let advertType: AdvertTypes

    var label: String {
        switch advertType {
        case .band:
            return "looking_for_a_band"
        case .musician:
            return "looking_for_a_musician"
        case .rental:
            return "hire_musician_band"
        }
    }


    var name: String {
        switch advertType {
        case .musician:
            return "create_musician_card"
        case .band:
            return "create_band_card"
        case .rental:
            return "hire_musician_band_card"
        }
    }

    init(advertType: AdvertTypes,
         skills: String,
         musicGenres: String,
         location: String,
         explanation: String) {
        self.advertType = advertType
        self.skills = skills
        self.musicGenres = musicGenres
        self.location = location
        self.explanation = explanation
        let keyForSkills: String = (advertType == .musician) ? "musician_type" : "instrument_played"
        self.parameters = [
            "location": location,
            "explanation": explanation,
            "music_style": musicGenres,
            keyForSkills: skills
        ]
    }
}
