//
//  VisitedAccountAdvertsCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 11.12.22.
//

import UIKit

final class VisitedAccountAdvertsCoordinator: Coordinator {

    typealias Controller = VisitedAccountAdvertsViewController

    weak var navigator: Navigator?

    init(navigator: Navigator? = nil) {
        self.navigator = navigator
    }

    func advert(with id: Int, colorCode: String) {
        AdvertCoordinator().start(with: id, colorCode: colorCode)
    }
}
