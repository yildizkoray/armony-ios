//
//  InternetConnectionService.swift
//  Armony
//
//  Created by Koray Yildiz on 21.01.23.
//

import Foundation
import Network

public class InternetConnectionService {

    private var connectionStatusDidChangeNotification: NotificationToken?
    private let notifier: NotificationCenter = .default

    enum Status: String {
        case online, offline, notDetermined
    }

    public static let shared = InternetConnectionService(monitor: .init())

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.armonyapp.internetconnectionservice")


    public var isConnected: Bool {
        status == .online || status == .notDetermined
    }

    private var status: Status = .notDetermined {
        didSet {
            guard oldValue != status else { return }
            guard oldValue != .notDetermined || status != .online else { return }
            NotificationCenter.default.post(notification: .internetConnectionDidChange,
                                            object: self,
                                            userInfo: [.isConnectedToInternet: isConnected])
        }
    }

    init(monitor: NWPathMonitor) {
        self.monitor = monitor
    }

    func start() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            switch path.status {
            case .satisfied:
                self?.status = .online

            case .requiresConnection, .unsatisfied:
                self?.status = .offline

            @unknown default:
                self?.status = .offline
            }
        }
    }

    public func addConnectionStatusChangeHandler(_ handler: @escaping Callback<Notification>) {
        connectionStatusDidChangeNotification = notifier.observe(
            name: .internetConnectionDidChange,
            using: { [unowned self] notification in
                handler(notification)
                self.notifier.removeObserver(self.connectionStatusDidChangeNotification as Any)
            }
        )
    }
}
