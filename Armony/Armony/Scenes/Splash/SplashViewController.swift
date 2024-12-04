//
//  SplashViewController.swift
//  Armony
//
//  Created by Koray Yıldız on 11.02.2022.
//

import UIKit

final class SplashViewController: UIViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .splash
    
    var viewModel: SplashViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
    }
}

