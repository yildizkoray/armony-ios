//
//  MixPanelScreenViewEvent.swift
//  Armony
//
//  Created by Koray Yildiz on 06.03.23.
//

import Foundation

struct MixPanelScreenViewEvent: MixPanelContext {
    var name: String
    var parameters: Payload

    init(name: String = "screenView", parameters: Payload) {
        self.name = name
        self.parameters = parameters
    }
}

struct MixPanelClickEvent: MixPanelContext {
    var name: String
    var parameters: Payload

    init(name: String = "buttonClicked", parameters: Payload) {
        self.name = name
        self.parameters = parameters
    }
}
