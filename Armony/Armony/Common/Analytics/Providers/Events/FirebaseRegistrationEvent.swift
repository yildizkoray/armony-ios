//
//  FirebaseRegistrationEvent.swift
//  Armony
//
//  Created by Koray Yıldız on 28.11.22.
//

import Foundation
import FirebaseAnalytics

struct LoginFirebaseEvent: FirebaseEvent {
    var category: String = "User Interaction"
    var label: String
    var action: String = "Login"
    var name: String = AnalyticsEventLogin
    var parameters: Payload = .empty
}


struct RegisterFirebaseEvent: FirebaseEvent {
    var category: String = "User Interaction"
    var label: String
    var action: String = "Register"
    var name: String = AnalyticsEventSignUp
    var parameters: Payload = .empty
}

struct LogoutFirebaseEvent: FirebaseEvent {
    var category: String = "User Interaction"
    var label: String = .empty
    var action: String = "Logout"
    var name: String = "logout"
    var parameters: Payload = .empty
}

protocol FirebaseManuelScreenViewing {
    func trackScreenView(parameters: FirebaseEvent.Payload)
}

struct FirebaseManuelScreenViewEvent: FirebaseEvent {
    var name: String = AnalyticsEventScreenView
    var defaultParameters: Payload
    var parameters: Payload

    init(scene: String, sceneClassName: String, parameters: Payload = .empty) {
        self.defaultParameters = [
            AnalyticsParameterScreenName: scene,
            AnalyticsParameterScreenClass: sceneClassName
        ]
        self.parameters = parameters
    }
}
