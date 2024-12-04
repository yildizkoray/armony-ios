//
//  AdListingViewModel.swift
//  Armony
//
//  Created by KORAY YILDIZ on 17/09/2024.
//

import Foundation

final class AdvertListingViewModel: ViewModel, ObservableObject {

    enum State {
        case data
        case empty
        case loading
    }

    @Published var cards: [CardPresentation]
    @Published var state: State

    var coordinator: AdvertListingCoordinator!

    init() {
        self.cards = .empty
        self.state = .loading
        super.init()
    }

    @MainActor
    func fetchAdverts() async {
        state = .loading
        do {
            let response = try await service.execute(
                task: GetExternalAdvertsTask(),
                type: RestArrayResponse<Advert>.self
            )
            cards = response.data.map { CardPresentation(advert: $0) }
            state = cards.isEmpty ? .empty : .data
        }
        catch let error {
            error.showAlert()
        }
    }
}
