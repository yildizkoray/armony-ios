//
//  AvatarViewModel.swift
//  Armony
//
//  Created by Koray Yıldız on 25.02.2024.
//

import Foundation

final class AvatarViewModel {
    var coordinator: AvatarCoordinator!
    private(set) var imageSource: ImageSource

    init(imageSource: ImageSource) {
        self.imageSource = imageSource
    }
}
