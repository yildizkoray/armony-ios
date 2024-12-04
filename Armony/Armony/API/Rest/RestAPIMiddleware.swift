//
//  RestAPIMiddleware.swift
//  Armony
//
//  Created by Koray Yıldız on 16.02.2022.
//

import Alamofire
import Foundation

final class RestAPIMiddleware: RequestInterceptor {

    private let whiteListForRetry = [
        "/auth/signin",
        "/auth/signup",
        "auth/reset-password",
        "/auth/refresh"
    ]

    private let timeZone: TimeZone = .autoupdatingCurrent
    private let locale: Locale = .autoupdatingCurrent

    public typealias RequestRetryCompletion = (RetryResult) -> Void
    private var waitingRequests: [RequestRetryCompletion]

    private lazy var tokenRestService: RestService = RestService(backend: .factory())

    private let authenticator: AuthenticationService

    init(authenticator: AuthenticationService = .shared) {
        self.authenticator = authenticator
        waitingRequests = [RequestRetryCompletion]()
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {

        var urlRequest = urlRequest
        urlRequest.setValue("IOS", forHTTPHeaderField: "Client-Type") // TODO: - Localizable

        if let timeZoneName = timeZone.localizedName(for: .standard, locale: locale) {
            urlRequest.setValue(timeZoneName, forHTTPHeaderField: "Time-Zone-Name") // TODO: - Localizable
            urlRequest.setValue(timeZone.abbreviation(), forHTTPHeaderField: "Time-Zone") // TODO: - Localizable
        }

        for (key, value) in authenticator.additionalHTTPHeaders where value.isNotEmpty {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let requestURLString = request.request?.url?.absoluteString
        let isWhiteListRequest = whiteListForRetry.first(where: { requestURLString.emptyIfNil.contains($0)}).isNil
        if let response = request.response {
            if response.statusCode == NSHTTPURLResponseTokenExpiredStatusCode,
               isWhiteListRequest {
                FirebaseCrashlyticsLogger.shared.log(exception:
                        .init(name: "RestService",
                              reason: "NSHTTPURLResponseTokenExpiredStatusCode")
                )
                waitingRequests.append(completion)
                refreshToken()
            }
            else {
                completion(.doNotRetry)
            }
        }
    }

    private func refreshToken() {
        Task {
            do {
                let request = RefreshTokenRequest(refreshToken: authenticator.refreshToken)
                let response = try await tokenRestService.execute(
                    task: PostRefreshTokenTask(request: request), type: RestObjectResponse<RefreshTokenResponse>.self
                )
                safeSync {
                    authenticator.identify(accessToken: response.data.access, refreshToken: response.data.refresh)
                    waitingRequests.forEach { $0(.retry) }
                    waitingRequests.removeAll()
                }
            }
            catch {
                safeSync {
                    authenticator.unauthenticate()
                    LoginCoordinator().start { [weak self] in
                        self?.waitingRequests.forEach { $0(.doNotRetry) }
                        self?.waitingRequests.removeAll()
                    } registrationCompletion: { [weak self] in
                        self?.waitingRequests.forEach { $0(.doNotRetry) }
                        self?.waitingRequests.removeAll()
                    }
                }
            }
        }
    }
}
