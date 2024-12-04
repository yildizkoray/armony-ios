import Foundation

public struct Deeplink: CustomStringConvertible, ExpressibleByStringLiteral {

    private let path: URLConvertible

    public init(stringLiteral value: String) {
        self.path = value
    }

    private init(path: URLConvertible) {
        self.path = path
    }

    public var description: String {
        return path.urlString
    }

    // MARK: - EMPTY
    public static let empty = Deeplink(stringLiteral: .empty)
}

// MARK: - Decodable
extension Deeplink: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        path = try container.decode(String.self)
    }
}
