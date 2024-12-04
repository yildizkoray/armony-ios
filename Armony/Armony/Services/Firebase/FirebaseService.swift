//
//  FirebaseService.swift
//  Armony
//
//  Created by Koray Yıldız on 18.02.2022.
//

import Foundation
import Firebase

public protocol FirebaseServiceProtocol {
    
    var configFilePath: String { get }

    func start()
}

public final class FirebaseService: FirebaseServiceProtocol {

    public static let shared = FirebaseService(for: ConfigReader.shared.environment, in: .main)

    private let environment: ConfigReader.Environment
    private let bundle: Bundle

    public var configFilePath: String {
        switch environment {
        case .debug:
            return bundle.path(forResource: "GoogleService-Info-Debug", ofType: ".plist").emptyIfNil
        case .release:
            return bundle.path(forResource: "GoogleService-Info", ofType: ".plist").emptyIfNil
        }
    }

    init(for environment: ConfigReader.Environment, in bundle: Bundle) {
        self.bundle = bundle
        self.environment = environment
    }

    public func start() {
        if let firebaseOptions = FirebaseOptions(contentsOfFile: configFilePath) {
            FirebaseApp.configure(options: firebaseOptions)
        }
    }
}
