//
//  UserAdvertsCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 24.05.22.
//

import UIKit

final class UserAdvertsCoordinator: Coordinator {

    typealias Controller = UserAdvertsViewController

    weak var navigator: Navigator?

    init(navigator: Navigator?) {
        defer {
            self.navigator = navigator
        }
        let view = createViewController()
        let viewModel = UserAdvertsViewModel(view: view)
        view.viewModel = viewModel
    }

    func advert(with id: Int, colorCode: String, dismissCompletion: @escaping Callback<Bool>) {
        AdvertCoordinator().start(with: id, colorCode: colorCode, isRemoveAdvertsActive: true, dismiss: dismissCompletion)
    }
}
