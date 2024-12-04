//
//  FeedbackViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 17.07.22.
//

import UIKit

protocol FeedbackViewDelegate: AnyObject {
    var detailText: String { get }

    func configureDetailTextView(with presentation: TextViewPresentation)
    func setSubjectDropdownText(_ text: String?)

    func startFeedbackSubjectActivityIndicatorView()
    func stopFeedbackSubjectActivityIndicatorView()

    func startSendButtonActivityIndicatorView()
    func stopSendButtonActivityIndicatorView()
}

final class FeedbackViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .settings

    @IBOutlet private weak var subjectDropdownView: ValidatableDropdownView!
    @IBOutlet private weak var detailSubjectTextView: ValidatableTextView!
    @IBOutlet private weak var sendButton: UIButton!

    var viewModel: FeedbackViewModel!

    private lazy var validationResponders: ValidationResponders = ValidationResponders(
        required: [subjectDropdownView, detailSubjectTextView]
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.viewDidLoad()

        title = String(localized: "Feedback.Title", table: "Feedback+Localizable")

        configureSendButton()

        subjectDropdownView.addTapGestureRecognizer(cancelsTouches: false) { [weak self] _ in
            self?.viewModel.subjectDropdownViewDidTap()
        }

        view.addTapGestureRecognizer(cancelsTouches: false) { [weak self] _ in
            self?.view.endEditing(true)
        }

        detailSubjectTextView.rules = ValidationRuleSet(
            rules: [
                Validation.Rule.Length(min: 15, max: 250, error: .empty)
            ]
        )
        
        validationResponders.didValidate = { [weak self] result in
            self?.sendButton.isEnabled = result.isValid
            self?.sendButton.backgroundColor = result.isValid ? .armonyPurple : .armonyPurpleLow
        }
    }

    @IBAction private func sendButtonDidTap() {
        viewModel.sendButtonDidTap()
    }



    private func configureUI() {
        view.backgroundColor = .armonyBlack
        subjectDropdownView.configure(with: .feedback)
    }

    private func configureSendButton() {
        sendButton.setTitle(
            String(localized: "Feedback.SubmitButton.Title", table: "Feedback+Localizable"),
            for: .normal
        )
        sendButton.setTitleColor(.armonyWhite, for: .normal)
        sendButton.setTitleColor(.armonyWhiteMedium, for: .disabled)
        sendButton.titleLabel?.font = .semiboldHeading
        sendButton.isEnabled = false
        sendButton.backgroundColor = .armonyPurpleLow
        sendButton.makeAllCornersRounded(radius: .medium)
    }
}

// MARK: - FeedbackViewDelegate
extension FeedbackViewController: FeedbackViewDelegate {
    var detailText: String {
        detailSubjectTextView.textView.text.emptyIfNil
    }

    func configureDetailTextView(with presentation: TextViewPresentation) {
        detailSubjectTextView.configure(with: presentation)
    }

    func setSubjectDropdownText(_ text: String?) {
        subjectDropdownView.updateText(text)
    }

    func startFeedbackSubjectActivityIndicatorView() {
        subjectDropdownView.startActivityIndicatorView()
    }

    func stopFeedbackSubjectActivityIndicatorView() {
        subjectDropdownView.stopActivityIndicatorView()
    }

    func startSendButtonActivityIndicatorView() {
        sendButton.startActivityIndicatorView()
    }

    func stopSendButtonActivityIndicatorView() {
        sendButton.stopActivityIndicatorView()
    }
}
