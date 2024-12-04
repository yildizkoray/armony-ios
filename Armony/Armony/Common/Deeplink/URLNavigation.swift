import UIKit

public typealias URLPattern = String
public typealias URLPatternHandler = Callback<URLNavigationResult>

public protocol URLNavigation {
    @discardableResult func open(_ deeplink: Deeplink, dismissToRoot: Bool) -> Bool
    func register(coordinator: URLNavigatable, pattern: Deeplink, handler: @escaping URLPatternHandler)
}

public extension URLNavigation {
    @discardableResult func open(_ deeplink: Deeplink) -> Bool {
        return open(deeplink, dismissToRoot: false)
    }
}
