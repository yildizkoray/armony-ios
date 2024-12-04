//
//  FilterCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 08.06.23.
//

import UIKit

final class FilterCoordinator: Coordinator {

    typealias Controller = FilterViewController

    weak var navigator: Navigator?

    func start(navigatee: Navigator?,
               delegate: FilterViewModelDelegate?, selectedFilters: FilterViewModel.Filters = .empty) {
        let view = createViewController()
        let viewModel = FilterViewModel(view: view, selectedFilters: selectedFilters)
        viewModel.coordinator = self
        viewModel.delegate = delegate

        view.viewModel = viewModel

        let navigator = Navigator(rootViewController: view)
        self.navigator = navigator

        navigatee?.present(navigator, animated: true)
    }
}
