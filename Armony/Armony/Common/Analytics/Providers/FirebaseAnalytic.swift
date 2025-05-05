//
//  FirebaseAnalytic.swift
//  Armony
//
//  Created by Koray Yıldız on 28.11.22.
//

import Foundation
import FirebaseAnalytics

protocol FirebaseEvent: Event {

    typealias Payload = [String: String]

    var name: String { get }
    var category: String { get }
    var label: String { get }
    var action: String { get }

    var defaultParameters: Payload { get }
    var parameters: Payload { get }
}

extension FirebaseEvent {

    var action: String {
        return .empty
    }

    var category: String {
        return .empty
    }

    var label: String {
        return .empty
    }

    var parameters: Payload {
        return .empty
    }

    var defaultParameters: Payload {
        return [
            "event_category": category,
            "event_action": action,
            "event_label": label,
            "customer_id": AuthenticationService.shared.userID
        ]
    }

    var eventParameters: Payload {
        let events = defaultParameters.merging(parameters) { _, new in new }
        if !shouldRemoveIfEventValueEmpty {
            return events
        }

        return events.filter { _, value in
            return value.isNotEmpty
        }
    }
}

extension FirebaseEvent {
    func send() {
        FirebaseAnalytic.shared.send(event: self)
    }
}

final class FirebaseAnalytic: NSObject, Analytic {

    typealias Event = FirebaseEvent
    let authenticator: AuthenticationService = .shared
    private var logoutToken: NotificationToken? = nil

    static let shared = FirebaseAnalytic()
    private let logger: FirebaseEventLogger = .shared

    func start() {
        addNotifications(
            authenticator.addLogoutHandler({ [unowned self] _ in
                self.userDidLogout()
            }),
            authenticator.addLoginHandler({ [unowned self] notification in
                if let user: ArmonyUser = notification[.user] {
                    self.setUserID(user.id)
                    self.setUserProperty(value: "Registered", key: "user_customertype")
                    self.setUserProperty(value: user.email.emptyIfNil, key: "customer_hashed_email")
                    self.setUserProperty(value: user.id, key: "customer_id")
                }
            })
        )
    }

    @objc private func userDidLogout() {
        setUserID(.empty)
        setUserProperty(value: "Guest", key: "user_customertype")
        setUserProperty(value: .empty, key: "customer_hashed_email")
        setUserProperty(value: .empty, key: "customer_id")
        LogoutFirebaseEvent().send()
    }

    func send(event: Event) {
        logger.log(event: event)
        Analytics.logEvent(event.name, parameters: event.eventParameters)
    }

    func setUserID(_ userID: String) {
        Analytics.setUserID(userID)
    }

    func setUserProperty(value: String, key: String) {
        Analytics.setUserProperty(value, forName: key)
    }
}

// MARK: - FirebaseEventLogger

final class FirebaseEventLogger {
    static let shared = FirebaseEventLogger()

    func log(event: FirebaseEvent) {
        let randomEmoji = Common.instrumentEmojis.randomElement()!
        print(
            print(randomEmoji + " Firebase Event: \(event.name)\n\(event.eventParameters as AnyObject)")
        )
    }
}
