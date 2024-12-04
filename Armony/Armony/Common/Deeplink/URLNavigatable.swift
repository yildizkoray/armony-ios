import Foundation

public protocol URLNavigatable {
    var isAuthenticationRequired: Bool { get}
    static var deeplink: Deeplink { get }

    static var instance: URLNavigatable { get }

    static func register(navigator: URLNavigation)
}

extension URLNavigatable {
    static var deeplink: Deeplink {
        .accountInformation
    }
}
