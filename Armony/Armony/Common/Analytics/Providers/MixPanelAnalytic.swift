//
//  MixPanelAnalytic.swift
//  Armony
//
//  Created by Koray Yildiz on 05.03.23.
//

import Foundation
import Mixpanel
import UIKit

protocol MixPanelContext: Event {
    typealias Payload = Properties

    var name: String { get }
    var parameters: Payload { get }
}

extension MixPanelContext {
    func send() {
        MixPanelAnalytic.shared.send(event: self)
    }
}

class MixPanelAnalytic: Analytic {

    typealias Event = MixPanelContext

    static let shared = MixPanelAnalytic()

    private var token: String {
        return ConfigReader.shared["MIXPANEL_TOKEN"]
    }

    private lazy var instance = Mixpanel.mainInstance()

    func start(options: [UIApplication.LaunchOptionsKey: Any]?) {
        Mixpanel.initialize(token: token, launchOptions: options)
        instance.loggingEnabled = false
        instance.identifyTemporarily()
        instance.trackAutomaticEventsEnabled = true

        NotificationCenter.default.addObserver(self, selector: #selector(configure(notification:)), name: .userLoggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: .userLoggedOut, object: nil)
    }

    func send(event: MixPanelContext) {
        Mixpanel.mainInstance().track(event: event.name, properties: event.parameters)
    }

    @objc func configure(notification: Notification) {
        guard let user: ArmonyUser = notification[.user] else { return }
        instance.identify(distinctId: user.id)
        instance.people.set(properties: ["$email": user.email])
        instance.people.set(properties: ["customer_id": user.id])
        instance.people.set(property: "user_customertype", to: "Registered")
        instance.people.set(property: "customer_hashed_email", to: user.email.emptyIfNil)
    }

    @objc func userDidLogout() {
        let guestProperties = [
            "customer_id": "",
            "user_customertype": "Guest",
            "customer_hashed_email": ""
        ]
        instance.people.set(properties: ["$email": ""])
        instance.people.set(properties: guestProperties)
        instance.reset()
    }
}

private extension MixpanelInstance {
    func configureLogging(for environment: ConfigReader.Environment) {
        switch environment {
        case .debug:
            loggingEnabled = true
        case .release:
            loggingEnabled = false
        }
    }

    func identifyTemporarily() {
        identify(distinctId: anonymousId.ifNil(distinctId))
    }

    func register(user: ArmonyUser) {
        createAlias(user.id, distinctId: distinctId)
    }
}
