//
//  Logger.swift
//  Armony
//
//  Created by Koray Yildiz on 08.03.23.
//

import Foundation
import FirebaseCrashlytics

protocol Logger {

    associatedtype Model

    func log(exception: Model)
    func log(error: Error?)
}

struct Exception {
    let name: String
    let reason: String

    init(name: String, reason: String) {
        self.name = name
        self.reason = reason
    }
}

final class FirebaseCrashlyticsLogger: Logger {

    typealias Model = Exception

    static let shared = FirebaseCrashlyticsLogger()

    private var crashlytics: Crashlytics

    private let authenticator: AuthenticationProviding = AuthenticationService.shared

    init() {
        self.crashlytics = Crashlytics.crashlytics()
        crashlytics.setCustomValue("userID", forKey: authenticator.userID)
    }

    func log(exception: Exception) {
        let exception = ExceptionModel(name: exception.name, reason: exception.reason)
        crashlytics.record(exceptionModel: exception)
    }

    func log(error: Error?) {
        if let error {
            crashlytics.record(error: error)
        }
    }
}
