//
//  MockURLNavigatable.swift
//  ArmonyTests
//
//  Created by KORAY YILDIZ on 29.09.2025.
//

import Foundation
@testable import Armony

class MockURLNavigatable: URLNavigatable {
    var isAuthenticationRequired: Bool = false
    var registerCalled = false
    var registerNavigator: URLNavigation?
    
    static var deeplink: Deeplink = .account
    
    static var instance: URLNavigatable {
        return MockURLNavigatable()
    }
    
    static func register(navigator: URLNavigation) {
        let mockInstance = MockURLNavigatable()
        mockInstance.registerCalled = true
        mockInstance.registerNavigator = navigator
    }
}

class MockAuthenticationRequiredNavigatable: URLNavigatable {
    var isAuthenticationRequired: Bool = true
    
    static var deeplink: Deeplink = .account
    
    static var instance: URLNavigatable {
        return MockAuthenticationRequiredNavigatable()
    }
    
    static func register(navigator: URLNavigation) {
        // Mock implementation
    }
}

class MockSettingsNavigatable: URLNavigatable {
    var isAuthenticationRequired: Bool = false
    
    static var deeplink: Deeplink = .settings
    
    static var instance: URLNavigatable {
        return MockSettingsNavigatable()
    }
    
    static func register(navigator: URLNavigation) {
        // Mock implementation
    }
}

class MockAdvertNavigatable: URLNavigatable {
    var isAuthenticationRequired: Bool = false
    
    static var deeplink: Deeplink = .advert
    
    static var instance: URLNavigatable {
        return MockAdvertNavigatable()
    }
    
    static func register(navigator: URLNavigation) {
        // Mock implementation
    }
}



