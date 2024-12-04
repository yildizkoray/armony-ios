//
//  LogOutBottomViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 10.07.22.
//

import Foundation
import BottomPopup
import UIKit

protocol LogOutBottomPopUpViewDelegate: AnyObject {
    func startLogoutButtonActivityIndicatorView()
    func stopLogoutButtonActivityIndicatorView()
}

final class LogOutBottomPopUpViewController: BottomPopupViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .settings

    var viewModel: LogOutBottomPopUpViewModel!

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var logOutButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .armonyBlack
        configureLabels()
        configureActionButtons()
    }

    @IBAction private func logOutTapped() {
        viewModel.logOut()
    }

    @IBAction private func cancelTapped() {
        viewModel.coordinator.dismiss()
    }

    private func configureLabels() {
        titleLabel.text = "Çıkış Yap"
        titleLabel.font = .semiboldTitle
        titleLabel.textColor = .armonyWhite


        subtitleLabel.text = "Uygulamadan çıkmak istediğinizden emin misiniz ?"
        subtitleLabel.font = .lightBody
        subtitleLabel.textColor = .armonyWhite
    }

    private func configureActionButtons() {
        logOutButton.setTitle("Çıkış Yap", for: .normal)
        logOutButton.backgroundColor = .armonyPurple
        logOutButton.setTitleColor(.armonyWhite, for: .normal)
        logOutButton.titleLabel?.font = .semiboldHeading

        cancelButton.setTitle("Vazgeç", for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.setTitleColor(.armonyWhite, for: .normal)
        cancelButton.titleLabel?.font = .lightBody
    }
}

// MARK: - LogOutBottomPopUpViewDelegate
extension LogOutBottomPopUpViewController: LogOutBottomPopUpViewDelegate {
    func startLogoutButtonActivityIndicatorView() {
        logOutButton.startActivityIndicatorView()
    }

    func stopLogoutButtonActivityIndicatorView() {
        logOutButton.stopActivityIndicatorView()
    }
}
