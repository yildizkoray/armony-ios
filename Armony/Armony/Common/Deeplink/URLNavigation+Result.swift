import UIKit

public final class URLNavigationResult {

    private let match: URLMatchResult

    public init(match: URLMatchResult) {
        self.match = match
    }

    public var view: UIViewController? {
        return UIViewController.topMostViewController
    }

    public var navigator: Navigator? {
        guard let view = view else { return .none }

        if let navigation = view as? UINavigationController {
            return navigation
        }
        else {
            return view.navigationController
        }
    }

    public var pattern: String {
        return match.pattern
    }

    public func value<T>(forKey key: String) -> T? {
        return match.queryValues[key] as? T
    }
}
