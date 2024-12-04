//
//  WebCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 30.03.23.
//

import UIKit

final class WebCoordinator: Coordinator {
    typealias Controller = WebViewController

    weak var navigator: Navigator?

    init(navigator: Navigator?) {
        self.navigator = navigator
    }

    func start(with url: String, title: String) {
        let view = createViewController()

        let viewModel = WebViewModel(urlString: url, title: title)
        view.viewModel = viewModel

        navigator?.pushViewController(view, animated: true)
    }
}

// MARK: - URLNavigatable
extension WebCoordinator: URLNavigatable {
    var isAuthenticationRequired: Bool {
        return false
    }

    static var instance: URLNavigatable {
        return WebCoordinator(navigator: nil)
    }

    static func register(navigator: URLNavigation) {
        navigator.register(coordinator: instance, pattern: .web) { result in
            if let title: String = result.value(forKey: "Title"),
               let url: String = result.value(forKey: "url") {
                WebCoordinator(navigator: result.navigator).start(with: url, title: title)
            }
        }
    }
}
