//
//  FeedbackViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 17.07.22.
//

import Foundation

final class FeedbackViewModel: ViewModel {
    var coordinator: FeedbackCoordinator!
    private weak var view: FeedbackViewDelegate?

    private var presentation: FeedbacksPresentation = .empty
    
    private var selectedSubjectID: Int? = nil
    
    init(view: FeedbackViewDelegate) {
        self.view = view
        super.init()
    }

    func subjectDropdownViewDidTap() {
        view?.startFeedbackSubjectActivityIndicatorView()
        service.execute(task: GetFeedbackSubjectsTask(), type: RestArrayResponse<FeedbackSubject>.self) { [weak self] result in
            self?.handleFeedbackSubjectsResult(result: result)
        }
    }

    func sendButtonDidTap() {
        guard let view = view else { return }

        guard let selectedSubjectID = selectedSubjectID,
              let subject = presentation.subjects.first(where: { $0.id == selectedSubjectID }),
              view.detailText.isNotEmpty else {
            return
        }

        let feedbackSubject = FeedbackSubject(id: subject.id, title: subject.title)
        let request = FeedbackRequest(feedbackSubject: feedbackSubject,
                                      message: view.detailText)
        view.startSendButtonActivityIndicatorView()
        service.execute(task: PostFeedbackTask(request: request), type: RestObjectResponse<EmptyResponse>.self) { [weak self] result in
            self?.view?.stopSendButtonActivityIndicatorView()
            switch result {
            case .success:
                let message = String(localized: "Feedback.Submission.Succes.Title", table: "Feedback+Localizable")
                AlertService.show(message: message, actions: [.okay(action: {
                    self?.coordinator.pop()
                })])

            case .failure(let error):
                AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }

    private func handleFeedbackSubjectsResult(result: NetworkResult<RestArrayResponse<FeedbackSubject>>) {
        view?.stopFeedbackSubjectActivityIndicatorView()
        switch result {
        case .success(let response):
            let items: [FeedbackSubjectSelectionInput] = response.data.map { subject in
                return FeedbackSubjectSelectionInput(
                    id: subject.id, title: subject.title, isSelected: subject.id == selectedSubjectID.ifNil(.max)
                )
            }
            presentation = FeedbacksPresentation(data: response.data)
            let selectionPresentation = FeedbackSubjectSelectionPresentation(delegate: self, items: items)
            coordinator.selectionBottomPopUp(with: selectionPresentation)
        case .failure(let error):
            AlertService.show(message: error.description, actions: [.okay()])
        }
    }
}

// MARK: - ViewModelLifeCycle
extension FeedbackViewModel: ViewModelLifeCycle {
    func viewDidLoad() {
        view?.configureDetailTextView(with: .feedback)
    }
}

// MARK: - FeedbackSubjectSelectionDelegate
extension FeedbackViewModel: FeedbackSubjectSelectionDelegate {
    func feedbackSubjectDidSelect(subject: SelectionInput?) {
        selectedSubjectID = subject?.id
        view?.setSubjectDropdownText(subject?.title)
    }
}
