//
//  SocketClient.swift
//  Armony
//
//  Created by Koray Yıldız on 25.11.22.
//

import Foundation
import Starscream

protocol SocketClientDelegate: AnyObject {

    var responseDecoder: SocketResponseDecoding { get }

    func socketDidConnect(client: SocketClient)
    func socketDidDisconnect(client: SocketClient)
    func socket(_ client: SocketClient, didDisconnectWithError error: Error?)
    func socket(_ client: SocketClient, didReceive response: String)
}

extension SocketClientDelegate {

    var responseDecoder: SocketResponseDecoding {
        return SocketResponseDecoder.shared
    }

    func socketDidConnect(client: SocketClient) { }
    func socketDidDisconnect(client: SocketClient) { }
    func socket(_ client: SocketClient, didDisconnectWithError error: Error?) { }
}

public class SocketClient {
    private let socket: WebSocket

    private weak var delegate: SocketClientDelegate?

    private var numberOfFailurePingAttempts: Int = .zero

    private var timer: Timer?
    private let pingTimeInterval: TimeInterval

    private let internetConnectionService: InternetConnectionService = .shared

    private var isConnected: Bool = false

    init(socketURL: URL, delegate: SocketClientDelegate, pingTimeInterval: TimeInterval = 5.0) {
        var request = URLRequest(url: socketURL)
        request.timeoutInterval = 10.0
        self.delegate = delegate
        self.pingTimeInterval = pingTimeInterval
        self.socket = WebSocket(request: request)
        self.socket.delegate = self
        self.addAppStateObservers()
    }

    deinit {
        timer?.invalidate()
        timer = nil
        closeConnection()
    }

    func openConnection() {
        closeConnection()
        socket.connect()

        timer = Timer.repeating(every: pingTimeInterval, block: { [weak self] in
            guard let self = self else { return }
            if self.numberOfFailurePingAttempts <= 5 {
                self.numberOfFailurePingAttempts += 1
                self.socket.write(ping: Data())
            }
            else {
                self.numberOfFailurePingAttempts = .zero
                self.openConnection()
            }
        })
    }

    func closeConnection() {
        timer?.invalidate()
        timer = nil
        socket.disconnect()
    }

    func write<T>(frame: Socket.Frame<T>, completion: VoidCallback? = .none) {
        if frame.messsage.isNotEmpty {
            socket.write(string: frame.messsage, completion: completion)
        }
    }

    func write(text: String, completion: VoidCallback? = .none) {
        if text.isNotEmpty {
            socket.write(string: text, completion: completion)
        }
    }

    private func addAppStateObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidEnterBackground(notification:)),
            name: .didEnterBackgroundNotification, object: .none
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillEnterForeground(notification:)),
            name: .willEnterForegroundNotification, object: .none
        )

        internetConnectionService.addConnectionStatusChangeHandler { [weak self] notification in
            if let isConnected: Bool = notification[.isConnectedToInternet], isConnected {
                self?.openConnection()
            }
            else {
                self?.closeConnection()
            }
        }
    }

    @objc private func applicationDidEnterBackground(notification: Notification) {
        closeConnection()
    }

    @objc private func applicationWillEnterForeground(notification: Notification) {
        openConnection()
    }
}

// MARK: - WebSocketDelegate
extension SocketClient: WebSocketDelegate {

    public func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected:
            isConnected = true
            delegate?.socketDidConnect(client: self)

        case .disconnected:
            isConnected = false
            delegate?.socketDidDisconnect(client: self)

        case .error(let error):
            isConnected = false
            delegate?.socket(self, didDisconnectWithError: error)
            FirebaseCrashlyticsLogger.shared.log(error: error)

        case .text(let response):
            SocketResponseLogger.log(response: response, url: socket.request.url?.absoluteString ?? .empty)
            delegate?.socket(self, didReceive: response)

        case .reconnectSuggested(let state):
            print("SocketDebug: reconnectSuggested", state)
            FirebaseCrashlyticsLogger.shared.log(exception:
                    .init(name: "SocketClient", reason: "reconnectSuggested - \(socket.request.url.ifNil(.localhost).absoluteString)")
            )

        case .viabilityChanged(let state):
            print("SocketDebug: viabilityChanged", state)
            FirebaseCrashlyticsLogger.shared.log(exception:
                    .init(name: "SocketClient", reason: "viabilityChanged - \(socket.request.url.ifNil(.localhost).absoluteString)")
            )

        case .cancelled:
            isConnected = false
            FirebaseCrashlyticsLogger.shared.log(exception:
                    .init(name: "SocketClient", reason: "cancelled - \(socket.request.url.ifNil(.localhost).absoluteString)")
            )

        case .binary:
            break

        case .ping:
            print("PingPingPingPingPingPingPingPingPingPingPingPingPing")

        case .pong:
            numberOfFailurePingAttempts = .zero
            print("PongPongPongPongPongPongPongPongPongPongPongPongPongPongPongPongPongPongPongPong")
        case .peerClosed:
            FirebaseCrashlyticsLogger.shared.log(exception:
                    .init(name: "SocketClient", reason: "peerClosed - \(socket.request.url.ifNil(.localhost).absoluteString)")
            )
        }
    }
}

fileprivate extension Timer {

    class func repeating(every: TimeInterval, block: @escaping () -> Void) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: every, repeats: true) { _ in block() }
    }
}

final class SocketResponseLogger {
    class func log(response: String, url: String) {
        guard let data = response.data(using: .utf8) else {
            return
        }

        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print("⌛️ SOCKET ⌛️:", url)
            print(String(decoding: jsonData, as: UTF8.self))
        } else {
            print("json data malformed")
        }
    }
}
