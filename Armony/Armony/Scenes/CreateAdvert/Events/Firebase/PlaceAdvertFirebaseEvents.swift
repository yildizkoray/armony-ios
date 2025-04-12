//
//  PlaceAdvertFirebaseEvents.swift
//  Armony
//
//  Created by Koray Yıldız on 23.12.2023.
//

import Foundation

struct PlaceAdvertFirebaseEvents: FirebaseEvent {
    var category: String = "Card"
    var action: String = "Create"
    var parameters: Payload
    let location: String
    let explanation: String

    var label: String = "KORAY"

    var name: String = "create_card"

    init(advertType: String,
         skills: String,
         musicGenres: String,
         location: String,
         explanation: String) {
        self.label = advertType
        self.location = location
        self.explanation = explanation
        self.parameters = [
            "location": location,
            "explanation": explanation
        ]
    }
}
