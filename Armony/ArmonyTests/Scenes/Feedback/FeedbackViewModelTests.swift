//
//  FeedbackViewModelTests.swift
//  ArmonyTests
//
//  Created by Koray Yildiz on 17.07.22.
//

import XCTest
@testable import Armony

final class FeedbackViewModelTests: XCTestCase {

    var mockView: MockFeedbackView!
    var mockRestService: MockRestService!
    var sut: FeedbackViewModel!
    var coordinator: FeedbackCoordinator!

    override func setUpWithError() throws {
        mockView = MockFeedbackView()
        mockRestService = MockRestService(backend: .factory())
        coordinator = .init()
        sut = FeedbackViewModel(view: mockView, service: mockRestService)
        sut.coordinator = coordinator
    }

    override func tearDownWithError() throws {
        mockView = nil
        mockRestService = nil
        sut = nil
    }

    func test_viewDidLoad_configuresDetailTextView() {
        // When
        sut.viewDidLoad()

        // Then
        XCTAssertTrue(mockView.invokedConfigureDetailTextView)
        XCTAssertEqual(mockView.invokedConfigureDetailTextViewParameters?.configuration.placeholder,
                       TextViewPresentation.feedback.placeholder)
    }

    func test_subjectDropdownViewDidTap_startsActivityIndicator() throws {
        // When
        sut.subjectDropdownViewDidTap()

        // Then
        XCTAssertTrue(mockView.invokedStartFeedbackSubjectActivityIndicatorView)
    }

    func test_subjectDropdownViewDidTap_whenSuccess_stopsActivityIndicator() async throws {
        // Given
        let subjects = [FeedbackSubject(id: 1, title: "Test Subject")]
        let response = RestArrayResponse<FeedbackSubject>(data: subjects, metadata: nil, error: nil)
        mockRestService.stubbedResult = response

        // When
        sut.subjectDropdownViewDidTap()
        try await Task.sleep(nanoseconds: 100_000_000) // Wait for async operation

        // Then
        XCTAssertTrue(mockView.invokedStopFeedbackSubjectActivityIndicatorView)
    }

    func test_subjectDropdownViewDidTap_whenError_showsAlert() async throws {
        // Given
        mockRestService.error = APIError.network

        // When
        sut.subjectDropdownViewDidTap()
        try await Task.sleep(nanoseconds: 100_000_000) // Wait for async operation

        // Then
        XCTAssertFalse(mockView.invokedStopFeedbackSubjectActivityIndicatorView)
    }

    func test_sendButtonDidTap_whenNoSubjectSelected_showsAlert() throws {
        // When
        let subjects = [FeedbackSubject(id: 1, title: "Test Subject")]
        let response = RestArrayResponse<FeedbackSubject>(data: subjects, metadata: nil, error: nil)
        mockRestService.stubbedResult = response
        sut.subjectDropdownViewDidTap()
        mockView.detailText = "Test"

        sut.feedbackSubjectDidSelect(subject: FeedbackSubjectSelectionInput(id: 1, title: "Koray", isSelected: true))
        sut.sendButtonDidTap()

        // Then
        XCTAssertFalse(mockView.invokedStartSendButtonActivityIndicatorView)
    }

    func test_feedbackSubjectDidSelect_whenNil_clearsDropdownText() throws {
        // When
        sut.feedbackSubjectDidSelect(subject: nil)

        // Then
        XCTAssertTrue(mockView.invokedSetSubjectDropdownText)
        XCTAssertNil(mockView.invokedSetSubjectDropdownTextParameters?.text)
    }
}
