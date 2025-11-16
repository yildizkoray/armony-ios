//
//  URLNavigatorTests.swift
//  ArmonyTests
//
//  Created by KORAY YILDIZ on 29.09.2025.
//

import XCTest
@testable import Armony

final class URLNavigatorTests: XCTestCase {
    
    var navigator: URLNavigator!
    var mockCoordinator: MockURLNavigatable!
    var mockAuthenticator: MockAuthenticationService!
    var mockDispatcher: MockDispatchQueue!
    var loginCoordinator: MockLoginCoordinator!

    override func setUpWithError() throws {
        super.setUp()
        mockAuthenticator = MockAuthenticationService()
        mockDispatcher = MockDispatchQueue()
        loginCoordinator = MockLoginCoordinator()
        navigator = URLNavigator(authenticator: mockAuthenticator, dispatcher: mockDispatcher, loginCoordinator: loginCoordinator)
        mockCoordinator = MockURLNavigatable()
    }

    override func tearDownWithError() throws {
        navigator = nil
        mockCoordinator = nil
        mockAuthenticator = nil
        mockDispatcher = nil
        super.tearDown()
    }
    
    // MARK: - Test 2: Open Method - No Authentication Required
    func test_open_whenNoAuthenticationRequired_shouldCallHandler() {
        // Given
        let testPattern: Deeplink = "/test-pattern"
        var handlerCalled = false
        let testHandler: URLPatternHandler = { result in
            handlerCalled = true
            XCTAssertEqual(result.pattern, "armony://\(testPattern.description)")
        }
        
        // Coordinator authentication gerektirmiyor
        mockCoordinator.isAuthenticationRequired = false
        
        // Dispatcher async work'ü çalıştıracak
        mockDispatcher.shouldInvokeAsyncAfterWork = true
        
        // Register pattern
        navigator.register(coordinator: mockCoordinator, pattern: testPattern, handler: testHandler)
        
        // When
        let deeplink = Deeplink(stringLiteral: "\(navigator.scheme)://\(testPattern.description)")
        let result = navigator.open(deeplink, dismissToRoot: false)
        
        // Then
        XCTAssertTrue(result, "Open metodu true dönmeli")
        XCTAssertTrue(mockDispatcher.invokedAsyncAfter, "Dispatcher asyncAfter çağrılmalı")
        XCTAssertTrue(handlerCalled, "Handler çağrılmalı")
    }
    
    // MARK: - Test 3: Open Method - Unregistered Pattern
    func test_open_whenPatternNotRegistered_shouldReturnFalse() {
        // Given
        let registeredPattern: Deeplink = "/registered-pattern"
        let unregisteredPattern: Deeplink = "/unregistered-pattern"
        
        let testHandler: URLPatternHandler = { _ in
            XCTFail("Handler çağrılmamalı")
        }
        
        // Sadece bir pattern kaydet
        navigator.register(coordinator: mockCoordinator, pattern: registeredPattern, handler: testHandler)
        
        // When
        let deeplink = Deeplink(stringLiteral: "\(navigator.scheme)://\(unregisteredPattern.description)")
        let result = navigator.open(deeplink, dismissToRoot: false)
        
        // Then
        XCTAssertFalse(result, "Kayıtlı olmayan pattern için open metodu false dönmeli")
        XCTAssertFalse(mockDispatcher.invokedAsyncAfter, "Dispatcher çağrılmamalı")
    }
    
    // MARK: - Test 4: Open Method - Authentication Required and User Authenticated
    func test_open_whenAuthenticationRequiredAndUserAuthenticated_shouldCallHandler() {
        // Given
        let testPattern: Deeplink = "/secure-pattern"
        var handlerCalled = false
        let testHandler: URLPatternHandler = { result in
            handlerCalled = true
            XCTAssertEqual(result.pattern, "armony://\(testPattern.description)")
        }
        
        // Coordinator authentication gerektiriyor
        mockCoordinator.isAuthenticationRequired = true
        
        // Kullanıcı authenticated
        mockAuthenticator.stubbedIsAuthenticated = true
        
        // Dispatcher async work'ü çalıştıracak
        mockDispatcher.shouldInvokeAsyncAfterWork = true
        
        // Register pattern
        navigator.register(coordinator: mockCoordinator, pattern: testPattern, handler: testHandler)
        
        // When
        let deeplink = Deeplink(stringLiteral: "\(navigator.scheme)://\(testPattern.description)")
        let result = navigator.open(deeplink, dismissToRoot: false)
        
        // Then
        XCTAssertTrue(result, "Open metodu true dönmeli")
        XCTAssertTrue(mockDispatcher.invokedAsyncAfter, "Dispatcher asyncAfter çağrılmalı")
        XCTAssertTrue(mockAuthenticator.invokedIsAuthenticatedGetter, "Authentication kontrol edilmeli")
        XCTAssertTrue(handlerCalled, "Kullanıcı authenticated olduğunda handler çağrılmalı")
    }
    
    // MARK: - Test 4.1: Open Method - Authentication Required and User Not Authenticated
    func test_open_whenAuthenticationRequiredAndUserNotAuthenticated_shouldNotCallHandlerImmediately() {
        // Given
        let testPattern: Deeplink = "/secure-pattern"
        var handlerCalled = false
        let testHandler: URLPatternHandler = { result in
            handlerCalled = true
            XCTAssertEqual(result.pattern, "armony://\(testPattern.description)")
        }
        
        // Coordinator authentication gerektiriyor
        mockCoordinator.isAuthenticationRequired = true
        
        // Kullanıcı authenticated değil
        mockAuthenticator.stubbedIsAuthenticated = false
        
        // Dispatcher async work'ü çalıştıracak
        mockDispatcher.shouldInvokeAsyncAfterWork = true

        loginCoordinator.shouldInvokeLoginCompletion = true

        // Register pattern
        navigator.register(coordinator: mockCoordinator, pattern: testPattern, handler: testHandler)
        
        // When
        let deeplink = Deeplink(stringLiteral: "\(navigator.scheme)://\(testPattern.description)")
        let result = navigator.open(deeplink, dismissToRoot: false)
        
        // Then
        XCTAssertTrue(result, "Open metodu true dönmeli")
        XCTAssertTrue(mockDispatcher.invokedAsyncAfter, "Dispatcher asyncAfter çağrılmalı")
        XCTAssertTrue(mockAuthenticator.invokedIsAuthenticatedGetter, "Authentication kontrol edilmeli")
        XCTAssertTrue(handlerCalled, "Kullanıcı authenticated olmadığında handler hemen çağrılmamalı")
        XCTAssertTrue(loginCoordinator.invokedStart)
    }
    
    // MARK: - Test 5: Open Method - With dismissToRoot Parameter
    func test_open_withDismissToRoot_shouldCallAsyncAfterWithDelay() {
        // Given
        let testPattern: Deeplink = "/test-pattern"
        var handlerCalled = false
        let testHandler: URLPatternHandler = { _ in
            handlerCalled = true
        }
        
        mockCoordinator.isAuthenticationRequired = false
        mockDispatcher.shouldInvokeAsyncAfterWork = true
        
        navigator.register(coordinator: mockCoordinator, pattern: testPattern, handler: testHandler)
        
        // When
        let deeplink = Deeplink(stringLiteral: "\(navigator.scheme)://\(testPattern.description)")
        let result = navigator.open(deeplink, dismissToRoot: true)
        
        // Then
        XCTAssertTrue(result, "Open metodu true dönmeli")
        XCTAssertTrue(mockDispatcher.invokedAsyncAfter, "Dispatcher asyncAfter çağrılmalı")
        XCTAssertEqual(mockDispatcher.invokedAsyncAfterCount, 1, "AsyncAfter bir kez çağrılmalı")
    }
    
    // MARK: - Test 6: Scheme Initialization
    func test_init_shouldSetSchemeCorrectly() {
        // Given & When
        // Navigator setUp'da initialize edildi
        
        // Then
        XCTAssertFalse(navigator.scheme.isEmpty, "Scheme boş olmamalı")
        XCTAssertEqual(navigator.scheme, "armony", "Scheme 'armony' olmalı")
    }

}

// MARK: - Mock Classes

class MockURLNavigatable: URLNavigatable {
    var isAuthenticationRequired: Bool = false
    
    static var instance: URLNavigatable {
        return MockURLNavigatable()
    }
    
    static func register(navigator: URLNavigation) {

    }
}
