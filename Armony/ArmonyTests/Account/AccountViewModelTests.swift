//
//  ArmonyTests.swift
//  ArmonyTests
//
//  Created by Koray Yıldız on 19.08.2021.
//

import XCTest
@testable import Armony
import KeychainAccess

final class AccountViewModelTests: XCTestCase {

    var mockView: MockAccountView!
    var mockRestService: MockRestService!
    var sut: AccountViewModel!
    var mockKeychain: Keychain!

    private let accountSuccessData = MockRestService.shared.load(fromJSONFile: "Account-Sample-Data", type: RestObjectResponse<UserDetail>.self)


    override func setUpWithError() throws {
        mockView = MockAccountView()
        mockRestService = MockRestService(backend: .factory())

        mockKeychain = Keychain(service: Bundle(for: type(of: self)).bundleIdentifier.emptyIfNil)
        let authenticator = AuthenticationService(keychain: mockKeychain)
        sut = AccountViewModel(view: mockView, authenticator: authenticator, service: mockRestService)
    }

    override func tearDownWithError() throws {
        mockView = nil
        mockRestService = nil
        mockKeychain = nil
        sut = nil
    }

    func test_viewDidLoad_InvokedViewMethods() throws {

        sut.viewDidLoad()

    }

    func test_viewWillAppear_() throws {
        XCTAssertFalse(mockView.invokedConfigureUserSummaryView)

        mockKeychain["Authorization"] = nil
        sut.viewWillAppear()

        XCTAssertTrue(mockView.invokedConfigureUserSummaryView)
        XCTAssertEqual(mockView.invokedConfigureUserSummaryViewParameters?.presentation.location?.string, .empty)
    }
}
