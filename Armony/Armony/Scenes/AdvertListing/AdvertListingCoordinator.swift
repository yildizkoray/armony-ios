//
//  AdvertListingCoordinator.swift
//  Armony
//
//  Created by KORAY YILDIZ on 17/09/2024.
//

import SwiftUI

final class AdvertListingCoordinator: SwiftUICoordinator {

    var navigator: Navigator?

    typealias Content = AdvertListingView
    typealias Controller = UIHostingController<AdvertListingView>

    init(navigator: Navigator? = nil) {
        self.navigator = navigator
    }

    func start() {
        let viewModel = AdvertListingViewModel()
        viewModel.coordinator = self
        let view = AdvertListingView(viewModel: viewModel)
        let hosting = createHostingViewController(rootView: view)
        hosting.title = "Zuhal Akademi"
        navigator?.pushViewController(hosting, animated: true)
    }

    func advert(id: Int, colorCode: String) {
        AdvertCoordinator().start(with: id, colorCode: colorCode)
    }
}

// MARK: - URLNavigatable
extension AdvertListingCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        false
    }
    
    static var instance: any URLNavigatable {
        AdvertListingCoordinator()
    }
    
    
    static func register(navigator: any URLNavigation) {
        navigator.register(coordinator: instance, pattern: .advertListing) { result in
            AdvertListingCoordinator(navigator: result.navigator).start()
        }
    }
}
