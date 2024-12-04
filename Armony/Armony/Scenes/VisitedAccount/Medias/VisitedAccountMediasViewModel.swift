//
//  VisitedAccountMediasViewModel.swift
//  Armony
//
//  Created by Koray Yıldız on 18.10.2023.
//

import Foundation

final class VisitedAccountMediasViewModel: ViewModel {

    var coordinator: VisitedAccountMediasCoordinator!
    private lazy var authenticator = AuthenticationService.shared

    var didFetchMedias: VoidCallback? = nil

    private(set) var presentation: UserMediasPresentation = .empty {
        didSet {
            didFetchMedias?()
        }
    }

    private var userID: String

    init(userID: String) {
        self.userID = userID
        super.init()
    }

    func fetchMedias() {
        Task {
            let task = GetMediasTask(userID: userID)
            do {
                let response = try await service.execute(
                    task: task,
                    type: RestArrayResponse<MediaItem>.self
                )
                let presentation = UserMediasPresentation(medias: response.data)
                self.presentation = presentation
            }
            catch let error {
                self.presentation = .empty
                error.showAlert()
            }
        }
    }
}
