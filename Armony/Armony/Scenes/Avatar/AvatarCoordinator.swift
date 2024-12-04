//
//  AvatarCoordinator.swift
//  Armony
//
//  Created by Koray Yıldız on 25.02.2024.
//

import UIKit

final class AvatarCoordinator: Coordinator {

    typealias Controller = AvatarViewController

    weak var navigator: Navigator?

    func start(onto navigation: Navigator?, imageSource: ImageSource) {
        let (avatarNavigator, view) = createNavigatorWithRootViewController()

        defer {
            self.navigator = avatarNavigator
        }
        
        let viewModel = AvatarViewModel(imageSource: imageSource)

        viewModel.coordinator = self
        view.viewModel = viewModel

        navigation?.present(avatarNavigator, animated: true)
    }
}
