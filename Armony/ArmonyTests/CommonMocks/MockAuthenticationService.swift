//
//  AuthenticationProviding.swift
//  Armony
//
//  Created by KORAY YILDIZ on 5.10.2025.
//

@testable import Armony

public class MockAuthenticationService: AuthenticationProviding {

    var invokedIsAuthenticatedGetter = false
    var invokedIsAuthenticatedGetterCount = 0
    var stubbedIsAuthenticated: Bool! = false

    public var isAuthenticated: Bool {
        invokedIsAuthenticatedGetter = true
        invokedIsAuthenticatedGetterCount += 1
        return stubbedIsAuthenticated
    }

    var invokedUserIDGetter = false
    var invokedUserIDGetterCount = 0
    var stubbedUserID: String! = ""

    public var userID: String {
        invokedUserIDGetter = true
        invokedUserIDGetterCount += 1
        return stubbedUserID
    }

    var invokedRefreshTokenGetter = false
    var invokedRefreshTokenGetterCount = 0
    var stubbedRefreshToken: String! = ""

    public var refreshToken: String {
        invokedRefreshTokenGetter = true
        invokedRefreshTokenGetterCount += 1
        return stubbedRefreshToken
    }

    var invokedAdditionalHTTPHeadersGetter = false
    var invokedAdditionalHTTPHeadersGetterCount = 0
    var stubbedAdditionalHTTPHeaders: [String: String]! = [:]

    public var additionalHTTPHeaders: [String: String] {
        invokedAdditionalHTTPHeadersGetter = true
        invokedAdditionalHTTPHeadersGetterCount += 1
        return stubbedAdditionalHTTPHeaders
    }

    var invokedAuthenticate = false
    var invokedAuthenticateCount = 0
    var invokedAuthenticateParameters: (accessToken: String, refreshToken: String, userID: String)?
    var invokedAuthenticateParametersList = [(accessToken: String, refreshToken: String, userID: String)]()

    public func authenticate(accessToken: String, refreshToken: String, userID: String) {
        invokedAuthenticate = true
        invokedAuthenticateCount += 1
        invokedAuthenticateParameters = (accessToken, refreshToken, userID)
        invokedAuthenticateParametersList.append((accessToken, refreshToken, userID))
    }

    var invokedUnauthenticate = false
    var invokedUnauthenticateCount = 0

    public func unauthenticate() {
        invokedUnauthenticate = true
        invokedUnauthenticateCount += 1
    }

    var invokedIdentify = false
    var invokedIdentifyCount = 0
    var invokedIdentifyParameters: (accessToken: String, refreshToken: String)?
    var invokedIdentifyParametersList = [(accessToken: String, refreshToken: String)]()

    public func identify(accessToken: String, refreshToken: String) {
        invokedIdentify = true
        invokedIdentifyCount += 1
        invokedIdentifyParameters = (accessToken, refreshToken)
        invokedIdentifyParametersList.append((accessToken, refreshToken))
    }
}
