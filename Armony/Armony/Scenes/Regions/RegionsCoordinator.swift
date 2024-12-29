//
//  RegionsCoordinator.swift
//  Armony
//
//  Created by KORAY YILDIZ on 17/12/2024.
//

import Foundation
import SwiftUI

@available(iOS 16, *)
final class RegionsCoordinator: SwiftUICoordinator {

    var navigator: Navigator?

    typealias Content = RegionsView
    typealias Controller = UIHostingController<RegionsView>

    init(navigator: Navigator? = nil) {
        self.navigator = navigator
    }

    func start() {
        let viewModel = RegionsViewModel()
        viewModel.coordinator = self
        let view = RegionsView(viewModel: viewModel)
        let hosting = createHostingViewController(rootView: view)
        hosting.title = "Region Seç"
        navigator?.pushViewController(hosting, animated: true)
    }
}

// MARK: - URLNavigatable
@available(iOS 16, *)
extension RegionsCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        false
    }
    
    static var instance: any URLNavigatable {
        RegionsCoordinator()
    }
    
    
    static func register(navigator: any URLNavigation) {
        navigator.register(coordinator: instance, pattern: .regions) { result in
            RegionsCoordinator(navigator: result.navigator).start()
        }
    }
}

