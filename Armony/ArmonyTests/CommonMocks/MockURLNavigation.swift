//
//  MockURLNavigation.swift
//  ArmonyTests
//
//  Created by KORAY YILDIZ on 29.09.2025.
//

import Foundation
@testable import Armony

class MockURLNavigation: URLNavigation {
    var openCalled = false
    var openDeeplink: Deeplink?
    var openDismissToRoot: Bool?
    var openReturnValue = false
    
    var registerCalled = false
    var registerCoordinator: URLNavigatable?
    var registerPattern: Deeplink?
    var registerHandler: URLPatternHandler?
    
    @discardableResult
    func open(_ deeplink: Deeplink, dismissToRoot: Bool) -> Bool {
        openCalled = true
        openDeeplink = deeplink
        openDismissToRoot = dismissToRoot
        return openReturnValue
    }
    
    func register(coordinator: URLNavigatable, pattern: Deeplink, handler: @escaping URLPatternHandler) {
        registerCalled = true
        registerCoordinator = coordinator
        registerPattern = pattern
        registerHandler = handler
    }
}

class MockURLNavigationResult: URLNavigationResult {
    private let mockPattern: String
    private let mockQueryValues: [String: String]
    
    init(pattern: String, queryValues: [String: String] = [:]) {
        self.mockPattern = pattern
        self.mockQueryValues = queryValues
        super.init(match: URLMatchResult(pattern: pattern, queryValues: queryValues))
    }
    
    override var pattern: String {
        return mockPattern
    }
    
    override func value<T>(forKey key: String) -> T? {
        return mockQueryValues[key] as? T
    }
}



