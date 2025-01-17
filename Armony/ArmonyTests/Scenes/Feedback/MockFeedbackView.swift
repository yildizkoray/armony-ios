//
//  MockFeedbackView.swift
//  ArmonyTests
//
//  Created by Koray Yildiz on 17.07.22.
//

import UIKit
@testable import Armony

final class MockFeedbackView: FeedbackViewDelegate {
    var detailText: String = ""

    var invokedConfigureDetailTextView = false
    var invokedConfigureDetailTextViewCount = 0
    var invokedConfigureDetailTextViewParameters: (configuration: TextViewPresentation, Void)?

    func configureDetailTextView(with configuration: TextViewPresentation) {
        invokedConfigureDetailTextView = true
        invokedConfigureDetailTextViewCount += 1
        invokedConfigureDetailTextViewParameters = (configuration, ())
    }
    
    var invokedStartFeedbackSubjectActivityIndicatorView = false
    var invokedStartFeedbackSubjectActivityIndicatorViewCount = 0
    
    func startFeedbackSubjectActivityIndicatorView() {
        invokedStartFeedbackSubjectActivityIndicatorView = true
        invokedStartFeedbackSubjectActivityIndicatorViewCount += 1
    }
    
    var invokedStopFeedbackSubjectActivityIndicatorView = false
    var invokedStopFeedbackSubjectActivityIndicatorViewCount = 0
    
    func stopFeedbackSubjectActivityIndicatorView() {
        invokedStopFeedbackSubjectActivityIndicatorView = true
        invokedStopFeedbackSubjectActivityIndicatorViewCount += 1
    }
    
    var invokedStartSendButtonActivityIndicatorView = false
    var invokedStartSendButtonActivityIndicatorViewCount = 0
    
    func startSendButtonActivityIndicatorView() {
        invokedStartSendButtonActivityIndicatorView = true
        invokedStartSendButtonActivityIndicatorViewCount += 1
    }
    
    var invokedStopSendButtonActivityIndicatorView = false
    var invokedStopSendButtonActivityIndicatorViewCount = 0
    
    func stopSendButtonActivityIndicatorView() {
        invokedStopSendButtonActivityIndicatorView = true
        invokedStopSendButtonActivityIndicatorViewCount += 1
    }
    
    var invokedSetSubjectDropdownText = false
    var invokedSetSubjectDropdownTextCount = 0
    var invokedSetSubjectDropdownTextParameters: (text: String?, Void)?
    
    func setSubjectDropdownText(_ text: String?) {
        invokedSetSubjectDropdownText = true
        invokedSetSubjectDropdownTextCount += 1
        invokedSetSubjectDropdownTextParameters = (text, ())
    }
} 
