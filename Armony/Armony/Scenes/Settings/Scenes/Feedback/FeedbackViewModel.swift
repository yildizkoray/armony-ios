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

    init(view: FeedbackViewDelegate, service: RestService = .init(backend: .factory())) {
        self.view = view
        super.init(service: service)
    }

    func subjectDropdownViewDidTap() {
        view?.startFeedbackSubjectActivityIndicatorView()
        Task {
            do {
                let response = try await service.execute(
                    task: GetFeedbackSubjectsTask(),
                    type: RestArrayResponse<FeedbackSubject>.self
                )
                
                await MainActor.run {
                    view?.stopFeedbackSubjectActivityIndicatorView()
                    handleFeedbackSubjectsResult(response: response)
                }
            }
            catch {
                error.showAlert()
            }
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
        Task {
            do {
                let _ = try await service.execute(
                    task: PostFeedbackTask(request: request),
                    type: RestObjectResponse<EmptyResponse>.self
                )
                
                await MainActor.run {
                    view.stopSendButtonActivityIndicatorView()
                    let message = String(localized: "Feedback.Submission.Succes.Title", table: "Feedback+Localizable")
                    AlertService.show(message: message, actions: [.okay(action: { [weak self] in
                        self?.coordinator.pop()
                    })])
                }
            }
            catch {
                error.showAlert()
            }
        }
    }

    private func handleFeedbackSubjectsResult(response: RestArrayResponse<FeedbackSubject>) {
        let items: [FeedbackSubjectSelectionInput] = response.data.map { subject in
            return FeedbackSubjectSelectionInput(
                id: subject.id, title: subject.title, isSelected: subject.id == selectedSubjectID.ifNil(.max)
            )
        }
        presentation = FeedbacksPresentation(data: response.data)
        let selectionPresentation = FeedbackSubjectSelectionPresentation(delegate: self, items: items)
        coordinator.selectionBottomPopUp(with: selectionPresentation)
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


final class MockFeedbackCoordinator: FeedbackCoordinator {
    override func selectionBottomPopUp(with presentation: any SelectionPresentation) { }
}
