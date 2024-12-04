//
//  FirebaseRemoteNotificationHandler.swift
//  Armony
//
//  Created by Koray Yıldız on 25.11.22.
//

import Foundation
import Alamofire
import FirebaseMessaging

final class FirebaseRemoteNotificationHandler: NSObject, RemoteNotificationHandler {

    static let shared = FirebaseRemoteNotificationHandler()
    private let authenticator: AuthenticationService = .shared
    private let service: RestService = .init(backend: .factory())

    private(set) var fcmToken: String?

    private let messaging = Messaging.messaging()

    func initialize() {
        messaging.delegate = self
        messaging.isAutoInitEnabled = true
    }

    func handle(token: Data) {
        messaging.apnsToken = token
    }
}

// MARK: - MessagingDelegate
extension FirebaseRemoteNotificationHandler: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if authenticator.isAuthenticated, let token = fcmToken {
            let request = PutFCMTokenRequest(fcmToken: token)
            service.execute(task: PutFCMToken(userID: authenticator.userID, request: request),
                            type: RestObjectResponse<EmptyResponse>.self) { result in
                switch result {
                case .failure:
                    let model = Exception(name: "FCMTokenUpdate", reason: "")
                    FirebaseCrashlyticsLogger.shared.log(exception: model)
                default:
                    break
                }
            }
        }
        self.fcmToken = fcmToken
    }
}

struct PutFCMToken: HTTPTask {
    var method: Alamofire.HTTPMethod = .put
    var path: String
    var body: Parameters?

    init(userID: String, request: PutFCMTokenRequest) {
        path = "/users/\(userID)/fcm-token"
        body = request.body()
    }
}

struct PutFCMTokenRequest: Encodable {
    let fcmToken: String
}
