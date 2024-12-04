//
//  MainPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 8.09.2021.
//

import Foundation

struct AdvertsPresentation {
    var cards: [CardPresentation]

    init(adverts: [Advert]) {
        self.cards = adverts.lazy.map(CardPresentation.init)
    }

    // MARK: - EMPTY
    static let empty = AdvertsPresentation(adverts: .empty)
}
