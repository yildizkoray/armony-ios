//
//  MessageCountSocketHandler.swift
//  Armony
//
//  Created by Koray Yildiz on 15.07.23.
//

import Foundation

final class MessageCountSocketHandler: NSObject {

    static let shared = MessageCountSocketHandler()

    private(set) var socket: SocketClient!

    private var authenticator: AuthenticationService! = .shared

    var count: MessageCount = .empty {
        didSet {
            NotificationCenter.default.post(
                notification: .messageCountDidChange,
                object: self,
                userInfo: [
                    .messageCount:count
                ]
            )
        }
    }

    override init() {
        super.init()
        addAuthenticationObservers()
    }

    func start() {
        if authenticator.isAuthenticated {
            do {
                let socketURL = try SocketMessageReadCountTask(userID: authenticator.userID).asURL()
                self.socket = SocketClient(socketURL: socketURL, delegate: self, pingTimeInterval: 30.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.socket.openConnection()
                }
            }
            catch let error {
                FirebaseCrashlyticsLogger.shared.log(error: error)
                AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }

    private func restart() {
        start()
    }

    private func addAuthenticationObservers() {
        addNotifications(
            authenticator.addLoginHandler({ [weak self] _ in
                self?.restart()
            }),
            authenticator.addLogoutHandler({ [weak self] _ in
                self?.reset()
            })
        )
    }
}

// MARK: - SocketClientDelegate
extension MessageCountSocketHandler: SocketClientDelegate {
    func socket(_ client: SocketClient, didReceive response: String) {
        do {
            count = try responseDecoder.decode(response: response, for: RestObjectResponse<MessageCount>.self).data
        }
        catch {
            print("Error decoding response: \(error)")
        }
    }
}

// MARK: - ResetHandling
extension MessageCountSocketHandler: ResetHandling {
    func reset() {
        count = .empty
        socket.closeConnection()
    }
}
