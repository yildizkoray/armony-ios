//
//  DeeplinkTests.swift
//  ArmonyTests
//
//  Created by KORAY YILDIZ on 29.09.2025.
//

import XCTest
@testable import Armony

final class DeeplinkTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testDeeplinkStringLiteralInitialization() {
        let deeplink: Deeplink = "/account"
        XCTAssertEqual(deeplink.description, "/account")
    }
    
    func testDeeplinkEmptyInitialization() {
        let deeplink = Deeplink.empty
        XCTAssertEqual(deeplink.description, "")
    }
    
    func testDeeplinkWithQueryParameters() {
        let deeplink: Deeplink = "/advert?id=123&category=electronics"
        XCTAssertEqual(deeplink.description, "/advert?id=123&category=electronics")
    }
    
    func testDeeplinkWithSpecialCharacters() {
        let deeplink: Deeplink = "/search?query=hello%20world&filter=price"
        XCTAssertEqual(deeplink.description, "/search?query=hello%20world&filter=price")
    }
    
    // MARK: - Description Tests
    
    func testDeeplinkDescription() {
        let deeplink: Deeplink = "/settings"
        XCTAssertEqual(deeplink.description, "/settings")
    }
    
    func testDeeplinkDescriptionWithComplexPath() {
        let deeplink: Deeplink = "/user/profile/edit?tab=personal"
        XCTAssertEqual(deeplink.description, "/user/profile/edit?tab=personal")
    }
    
    // MARK: - Decodable Tests
    
    func testDeeplinkDecodable() throws {
        let json = """
        "/account"
        """.data(using: .utf8)!
        
        let deeplink = try JSONDecoder().decode(Deeplink.self, from: json)
        XCTAssertEqual(deeplink.description, "/account")
    }
    
    func testDeeplinkDecodableWithQueryParameters() throws {
        let json = """
        "/advert?id=123&category=electronics"
        """.data(using: .utf8)!
        
        let deeplink = try JSONDecoder().decode(Deeplink.self, from: json)
        XCTAssertEqual(deeplink.description, "/advert?id=123&category=electronics")
    }
    
    func testDeeplinkDecodableInvalidJSON() {
        let json = """
        {"invalid": "json"}
        """.data(using: .utf8)!
        
        XCTAssertThrowsError(try JSONDecoder().decode(Deeplink.self, from: json))
    }
    
    // MARK: - Static Deeplink Tests
    
    func testStaticDeeplinkDefinitions() {
        XCTAssertEqual(Deeplink.account.description, "/account")
        XCTAssertEqual(Deeplink.accountInformation.description, "/account-information")
        XCTAssertEqual(Deeplink.advert.description, "/advert")
        XCTAssertEqual(Deeplink.advertListing.description, "/advert-listing")
        XCTAssertEqual(Deeplink.changePassword.description, "/change-password")
        XCTAssertEqual(Deeplink.chats.description, "/chats")
        XCTAssertEqual(Deeplink.placeAdvert.description, "/place-advert")
        XCTAssertEqual(Deeplink.feedback.description, "/feedback")
        XCTAssertEqual(Deeplink.liveChat.description, "/live-chat")
        XCTAssertEqual(Deeplink.logOut.description, "/logout")
        XCTAssertEqual(Deeplink.policy.description, "/policy")
        XCTAssertEqual(Deeplink.registration.description, "/registration")
        XCTAssertEqual(Deeplink.regions.description, "/regions")
        XCTAssertEqual(Deeplink.settings.description, "/settings")
        XCTAssertEqual(Deeplink.visitedAccount.description, "/visited-account")
        XCTAssertEqual(Deeplink.web.description, "/web")
    }
    
    // MARK: - Equality Tests
    
    func testDeeplinkEquality() {
        let deeplink1: Deeplink = "/account"
        let deeplink2: Deeplink = "/account"
        let deeplink3: Deeplink = "/settings"
        
        XCTAssertEqual(deeplink1.description, deeplink2.description)
        XCTAssertNotEqual(deeplink1.description, deeplink3.description)
    }
    
    // MARK: - URL Construction Tests
    
    func testDeeplinkURLConstruction() {
        let deeplink: Deeplink = "/account"
        let url = URL(string: "armony://\(deeplink.description)")
        
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "armony")
        XCTAssertEqual(url?.path, "/account")
    }
    
    func testDeeplinkURLConstructionWithQueryParameters() {
        let deeplink: Deeplink = "/advert?id=123&category=electronics"
        let url = URL(string: "armony://\(deeplink.description)")
        
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "armony")
        XCTAssertEqual(url?.path, "/advert")
        XCTAssertEqual(url?.query, "id=123&category=electronics")
    }
}

