//
//  PlaceAdvertFirebaseEvents.swift
//  Armony
//
//  Created by Koray Yıldız on 23.12.2023.
//

import Foundation

struct PlaceAdvertFirebaseEvents: FirebaseEvent {
    var name: String = "create_card"
    var category: String = "Card"
    var action: String = "Create"
    var label: String

    var parameters: Payload

    var shouldRemoveIfEventValueEmpty: Bool {
        true
    }

    init(label: String, parameters: Payload) {
        self.label = label
        self.parameters = parameters
    }
}
