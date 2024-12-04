//
//  AvatarViewController.swift
//  Armony
//
//  Created by Koray Yıldız on 25.02.2024.
//

import UIKit
import SnapKit

final class AvatarViewController: UIViewController, ViewController, NavigationBarCustomizing {

    static var storyboardName: UIStoryboard.Name = .none

    var viewModel: AvatarViewModel!

    private lazy var avatar = UIImageView()

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setBackgroundColor(.black)
        view.addSubview(avatar)
        addNotch()
        setDismissButton(completion: nil)

        avatar.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(avatar.snp.width)
        }

        avatar.setImage(source: viewModel.imageSource)
    }
}
