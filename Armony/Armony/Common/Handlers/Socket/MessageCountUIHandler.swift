//
//  MessageCountUIHandler.swift
//  Armony
//
//  Created by Koray Yildiz on 15.07.23.
//

import Foundation
import UIKit

final class MessageCountUIHandler: NSObject {

    static let shared = MessageCountUIHandler()

    private let notifier: NotificationCenter = .default

    private func addMessageCountHandler(_ handler: @escaping Callback<Notification>) -> NotificationToken {
        return notifier.observe(name: .messageCountDidChange, using: handler)
    }

    func start(with viewController: UIViewController) {
        addNotifications(addMessageCountHandler { [weak viewController] notification in

            guard let viewController = viewController else { return }

            if let chatsRightButton = viewController.navigationItem.rightBarButtonItem,
               let messageCount: MessageCount = notification[.messageCount] {
                if messageCount.count > .zero {
                    chatsRightButton.image = .homeMessagesUnreadIcon
                }
                else {
                    chatsRightButton.image = .homeMessagesIcon
                }
            }
        })
    }
}
