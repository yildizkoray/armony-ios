import Foundation

public protocol URLNavigatable {
    var isAuthenticationRequired: Bool { get}

    static var instance: URLNavigatable { get }

    static func register(navigator: URLNavigation)
}
