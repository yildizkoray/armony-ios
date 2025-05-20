//
//  UserMediasViewModel.swift
//  Armony
//
//  Created by Koray Yıldız on 14.10.2023.
//

import Foundation

final class UserMediasCoordinator: Coordinator {
    typealias Controller = UserMediasViewController
}

final class UserMediasViewModel: ViewModel {

    var coordinator: UserMediasCoordinator!
    private lazy var authenticator = AuthenticationService.shared

    var didFetchMedias: VoidCallback? = nil
    var toggleEmptyState: Callback<Bool>? = nil
    var stopEmptyStateActionButtomActivityIndicator: VoidCallback? = nil

    private(set) var presentation: UserMediasPresentation = .empty {
        didSet {
            didFetchMedias?()
            toggleEmptyState?(presentation.medias.isEmpty)
        }
    }

    func addNewVideo(url: String) {
        Task {
            let request = PostMediaItemRequest(link: url, type: MediaType.youtube.rawValue)
            let task = PostMediasTask(userID: authenticator.userID, request: request)

            let firebaseEventParameteres = [
                "performance_count": "1"
            ]

            do {
                let _ = try await service.execute(task: task, type: RestObjectResponse<EmptyResponse>.self)

                UploadYoutubeVideoAdjustEvent().send()
                UploadYoutubeVideoFirebaseEvent(parameters: firebaseEventParameteres).send()

                self.fetchMedias()
            }
            catch let error {
                stopEmptyStateActionButtomActivityIndicator?()
                if error.api?.status == 400 {
                    await AlertService.show(message: String(localized: "MyPerformances.AddVideo.Error.Message", table: "Account+Localizable"),
                                            actions: [.okay()])
                }
                else {
                    error.showAlert()
                }
            }
        }
    }

    func deleteMedia(id: Int, videoURL: URL) {
        Task {
            let task = DeleteMediasTask(userID: authenticator.userID, id: id)
            let firebaseEventParameteres = [
                "performance_count": "0"
            ]

            do {
                let _ = try await service.execute(task: task, type: RestObjectResponse<EmptyResponse>.self)
                DeleteYoutubeVideoFirebaseEvent(
                    label: videoURL.absoluteString,
                    parameters: firebaseEventParameteres
                ).send()
                DeleteYoutubeVideoAdjustEvent().send()
                self.fetchMedias()
            }
            catch let error {
                stopEmptyStateActionButtomActivityIndicator?()
                error.showAlert()
            }
        }
    }

    func fetchMedias() {
        Task {
            let task = GetMediasTask(userID: authenticator.userID)
            do {
                let response = try await service.execute(task: task, type: RestArrayResponse<MediaItem>.self)
                let presentation = UserMediasPresentation(medias: response.data)
                self.presentation = presentation
                stopEmptyStateActionButtomActivityIndicator?()
            }
            catch let error {
                stopEmptyStateActionButtomActivityIndicator?()
                error.showAlert()
            }
        }
    }
}

public extension Error {
    func showAlert() {
        AlertService.show(error: self.api, actions: [.okay()])
    }
}

// Adjust Event
struct UploadYoutubeVideoAdjustEvent: AdjustEvent {
    var token: String = "ru6jt5"
}

struct DeleteYoutubeVideoAdjustEvent: AdjustEvent {
    var token: String = "j8x9it"
}

struct UploadYoutubeVideoFirebaseEvent: FirebaseEvent {
    var category: String = "Performance"
    var label: String = "YouTube"
    var action: String = "Add"
    var name: String = "add_performance"
    var parameters: Payload
}

struct DeleteYoutubeVideoFirebaseEvent: FirebaseEvent {
    var category: String = "Performance"
    var label: String = "YouTube"
    var action: String = "Delete"
    var name: String = "delete_performance"
    var parameters: Payload
}
