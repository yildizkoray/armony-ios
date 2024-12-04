//
//  VisitedAccountMediasCoordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 18.10.2023.
//

import UIKit

final class VisitedAccountMediasCoordinator: Coordinator {
    typealias Controller = VisitedAccountMediasViewController

    weak var navigator: Navigator?

    init(navigator: Navigator? = nil) {
        self.navigator = navigator
    }
}
