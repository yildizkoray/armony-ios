//
//  FirebaseRegistrationEvent.swift
//  Armony
//
//  Created by Koray Yıldız on 28.11.22.
//

import Foundation
import FirebaseAnalytics

struct ScreenViewFirebaseEvent: FirebaseEvent {
    var category: String = .empty
    var label: String = .empty
    var action: String = .empty
    var name: String
    var parameters: Payload
}

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
