//
//  AdjustAnaltic.swift
//  Armony
//
//  Created by Koray Yildiz on 04.06.23.
//

import Foundation
import Adjust

protocol AdjustEvent: Event {
    var token: String { get }
}

extension AdjustEvent {
    func send() {
        AdjustAnaltic.shared.send(event: self)
    }
}

final class AdjustAnaltic: Analytic {
    typealias Event = AdjustEvent

    public static let shared = AdjustAnaltic()
    
    func start(with config: ConfigReader = .shared) {
        let appToken = ConfigReader.shared["ADJUST_TOKEN"]
        let environment = config.environment.isRelease ? ADJEnvironmentProduction : ADJEnvironmentSandbox
        let adjustConfig = ADJConfig(
            appToken: appToken,
            environment: environment
        )
        
        adjustConfig?.logLevel = ADJLogLevelInfo

        Adjust.appDidLaunch(adjustConfig)
    }
    
    func send(event: Event) {
        let event = ADJEvent(eventToken: event.token)
        Adjust.trackEvent(event)
    }
}

