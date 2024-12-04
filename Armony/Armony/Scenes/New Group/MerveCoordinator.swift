//
//  MerveCoordinator.swift
//  Armony
//
//  Created by Koray Yildiz on 17.07.22.
//

import UIKit

final class MerveCoordinator: Coordinator {

    typealias Controller = MerveViewController
    
    weak var navigationController: UINavigationController?
    
    init(with navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}
