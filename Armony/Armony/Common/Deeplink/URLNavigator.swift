import UIKit

public final class URLNavigator: URLNavigation {

    public static let shared: URLNavigator = .initialize(URLNavigator())

    public let scheme: String

    private var handlers = [URLPattern: (handler: URLPatternHandler, coordinator: URLNavigatable)]()

    private let authenticator: AuthenticationProviding
    private let dispatcher: DispatchQueueProtocol
    private var loginCoordinator: LoginCoordinator

    public init(
        authenticator: AuthenticationProviding = AuthenticationService.shared,
        dispatcher: DispatchQueueProtocol = DispatchQueue.main,
        loginCoordinator: LoginCoordinator = LoginCoordinator()
    ) {
        self.authenticator = authenticator
        self.dispatcher = dispatcher
        self.loginCoordinator = loginCoordinator
        self.scheme = Bundle(for: type(of: self)).urlScheme
    }

    private func handler(
        for url: URLConvertible
    ) -> (result: URLNavigationResult, coordinator: URLNavigatable)? {
        for (pattern, _) in handlers {
            if pattern.isMatched(with: url.path) {
                let match = URLMatchResult(pattern: pattern, queryValues: url.queryParameters)
                return (result: URLNavigationResult(match: match), coordinator: handlers[pattern]!.coordinator)
            }
        }
        return nil
    }

    @discardableResult
    public func open(_ deeplink: Deeplink, dismissToRoot: Bool) -> Bool {
        guard let result = handler(for: deeplink.description),
              let handler = handlers[result.result.pattern]?.handler else { return false }

        let handleBlock = { [weak self] in
            guard let self else { return }
            if result.coordinator.isAuthenticationRequired && !authenticator.isAuthenticated {
                loginCoordinator.start {
                    handler(result.result)
                } registrationCompletion: {
                    handler(result.result)
                }
            } else {
                handler(result.result)
            }
        }

        if dismissToRoot {
            UIViewController.topMostViewController?.dismissToRootViewController(animated: false) {
                self.dispatcher.asyncAfter(deadline: .now() + 0.15, execute: handleBlock)
            }
        }
        else {
            self.dispatcher.asyncAfter(deadline: .now() + 0.15, execute: handleBlock)
        }

        return true
    }

    public func register(coordinator: URLNavigatable, pattern: Deeplink, handler: @escaping URLPatternHandler) {
        handlers["\(scheme)://\(pattern)"] = (handler: handler, coordinator: coordinator)
    }
}

private extension String {
    
    func isMatched(with path: String) -> Bool {
        return URLComponents(string: self)?.path == path
    }
}
