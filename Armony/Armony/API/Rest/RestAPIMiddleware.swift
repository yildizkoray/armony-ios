//
//  RestAPIMiddleware.swift
//  Armony
//
//  Created by Koray Yıldız on 16.02.2022.
//

import Alamofire
import Foundation

/// Alamofire RequestInterceptor that handles authentication, request adaptation, and token refresh.
/// 
/// This middleware automatically adds required headers to all API requests and handles
/// token expiration by refreshing the access token and retrying failed requests.
/// It also manages region-specific headers and timezone information.
/// 
/// ## Key Features:
/// - **Request Adaptation**: Adds client type, region, timezone, and authentication headers
/// - **Token Refresh**: Automatically refreshes expired tokens and retries requests
/// - **Request Queuing**: Queues requests during token refresh to prevent race conditions
/// - **White-listed Endpoints**: Certain auth endpoints are excluded from retry logic
/// 
/// ## Usage:
/// ```swift
/// // Configure Alamofire session with middleware
/// let middleware = RestAPIMiddleware(authenticator: .shared)
/// let session = Session(interceptor: middleware)
/// 
/// // All requests through this session will automatically:
/// // - Include authentication headers
/// // - Handle token refresh on expiration
/// // - Retry failed requests after token refresh
/// ```
final class RestAPIMiddleware: RequestInterceptor {

    /// List of endpoints that should not be retried after token expiration.
    /// These are typically authentication endpoints that don't require a valid token.
    private let whiteListForRetry = [
        "/auth/signin",
        "/auth/signup",
        "auth/reset-password",
        "/auth/refresh"
    ]

    /// Current timezone for request headers
    private let timeZone: TimeZone = .autoupdatingCurrent
    
    /// Current locale for request headers
    private let locale: Locale = .autoupdatingCurrent

    /// Type alias for request retry completion handlers
    public typealias RequestRetryCompletion = (RetryResult) -> Void
    
    /// Queue of requests waiting for token refresh to complete
    private var waitingRequests: [RequestRetryCompletion]

    /// REST service instance for making token refresh requests
    private lazy var tokenRestService: RestService = RestService(backend: .factory())

    /// Authentication service for managing tokens and user state
    private let authenticator: AuthenticationService

    /// Initializes the middleware with an authentication service
    /// - Parameter authenticator: The authentication service to use for token management
    init(authenticator: AuthenticationService = .shared) {
        self.authenticator = authenticator
        waitingRequests = [RequestRetryCompletion]()
    }
    
    /// Adapts outgoing requests by adding required headers.
    /// 
    /// This method is called before each request and adds:
    /// - Client type header (iOS)
    /// - Region header (from user settings or current locale)
    /// - Timezone headers (name and abbreviation)
    /// - Authentication headers (from authenticator service)
    /// 
    /// - Parameters:
    ///   - urlRequest: The original URL request to adapt
    ///   - session: The Alamofire session
    ///   - completion: Completion handler with the adapted request or error
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {

        var urlRequest = urlRequest
        urlRequest.setValue("IOS", forHTTPHeaderField: "Client-Type")
        
        if Defaults.shared[.isRegionActive] {
            if let region: String = Defaults.shared[.region], region.isNotEmpty {
                urlRequest.setValue(region, forHTTPHeaderField: "Region")
            }
        }
        else {
            urlRequest.setValue(Locale.current.regionCode, forHTTPHeaderField: "Region")
        }

        if let timeZoneName = timeZone.localizedName(for: .standard, locale: locale) {
            urlRequest.setValue(timeZoneName, forHTTPHeaderField: "Time-Zone-Name")
            urlRequest.setValue(timeZone.abbreviation(), forHTTPHeaderField: "Time-Zone")
        }

        for (key, value) in authenticator.additionalHTTPHeaders where value.isNotEmpty {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        completion(.success(urlRequest))
    }

    /// Handles request retry logic for failed requests.
    /// 
    /// This method is called when a request fails and determines whether to retry.
    /// It specifically handles token expiration by:
    /// - Checking if the request is not in the white-list
    /// - Verifying the response status code indicates token expiration
    /// - Queuing the request for retry after token refresh
    /// - Limiting retry attempts to prevent infinite loops
    /// 
    /// - Parameters:
    ///   - request: The failed request
    ///   - session: The Alamofire session
    ///   - error: The error that caused the failure
    ///   - completion: Completion handler with retry decision
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let requestURLString = request.request?.url?.absoluteString
        let isWhiteListRequest = whiteListForRetry.first(where: { requestURLString.emptyIfNil.contains($0)}).isNil

        if let response = request.response {
            if response.statusCode == NSHTTPURLResponseTokenExpiredStatusCode,
               isWhiteListRequest,
               request.retryCount < 4 {
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

    /// Refreshes the access token and retries waiting requests.
    /// 
    /// This method:
    /// - Makes a token refresh request using the refresh token
    /// - Updates the authenticator with new tokens on success
    /// - Retries all waiting requests with the new token
    /// - Handles authentication failure by logging out the user
    /// - Manages the waiting requests queue
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
