//
//  InternetConnectionAlertService.swift
//  Armony
//
//  Created by Koray Yildiz on 22.01.23.
//

import Foundation
import SwiftMessages

public final class InternetConnectionAlertService {

    public static let shared = InternetConnectionAlertService(internetConnectionService: .shared)

    private let internetConnectionService: InternetConnectionService
    private let messages = SwiftMessages()

    init(internetConnectionService: InternetConnectionService = .shared) {
        self.internetConnectionService = internetConnectionService
    }

    func start() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(internetConnectionDidChange(notification:)),
            name: .internetConnectionDidChange,
            object: .none
        )
    }

    @objc private func internetConnectionDidChange(notification: Notification) {
        safeSync {
            let view = MessageView.viewFromNib(layout: .statusLine)

            view.bottomLayoutMarginAddition = 4.0
            view.configureTheme(.warning)

            var config = SwiftMessages.Config()
            config.presentationContext = .window(windowLevel: .statusBar)

            if let isConnected: Bool = notification[.isConnectedToInternet] {
                messages.hide()

                if isConnected {
                    view.bodyLabel?.text = "Tekrar baglandin"
                    config.interactiveHide = true
                    config.duration = .seconds(seconds: 3)
                    view.backgroundColor = .armonyGreen

                    view.tapHandler = { [weak self] _ in
                        self?.messages.hide()
                    }
                    messages.show(config: config, view: view)
                }
                else {
                    config.interactiveHide = false
                    config.duration = .forever
                    view.bodyLabel?.text = "Internet yok"
                    view.backgroundColor = .armonyRed
                    messages.show(config: config, view: view)
                }
            }
        }
    }
}
