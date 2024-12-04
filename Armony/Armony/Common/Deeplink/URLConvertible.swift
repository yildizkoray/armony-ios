//
//  URLConvertiblev.swift
//  Armony
//
//  Created by Koray Yıldız on 21.11.2023.
//

import UIKit

public protocol URLConvertible {

    var path: String { get }
    var url: URL? { get }
    var urlString: String { get }
    var queryParameters: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
}

public extension URLConvertible {

    var queryParameters: [String: String] {
        var queryParameters = [String: String]()

        queryItems.forEach { queryItem in
            queryParameters.update(queryItem.dictionary)
        }
        return queryParameters
    }

    var queryItems: [URLQueryItem] {
        if let armonyURLComponents {
            return armonyURLComponents.queryItems.ifNil([])
        }
        return []
    }

    var path: String {
        if let armonyURLComponents {
            return armonyURLComponents.path
        }
        return .empty
    }

    private var urlComponents: URLComponents? {
        return URLComponents(string: urlString.url.ifNil(.localhost).urlString)
    }

    private var armonyURLComponents: URLComponents? {
        var components = urlComponents
        components?.host = .empty
        components?.host = "armony"
        components?.addPathSeparatorIfNeeded()
        return components
    }
}

public extension CharacterSet {

    static let rfc3986Allowed: CharacterSet = {
        var characterSet = CharacterSet()

        characterSet.formUnion(.urlHostAllowed)
        characterSet.formUnion(.urlPathAllowed)
        characterSet.formUnion(.urlQueryAllowed)
        characterSet.formUnion(.urlFragmentAllowed)

        return characterSet
    }()
}

extension String: URLConvertible {

    public var url: URL? {
        if let url = URL(string: self) {
            return url
        }
        return addingPercentEncoding(withAllowedCharacters: .rfc3986Allowed).flatMap { URL(string: $0) }
    }

    public var urlString: String {
        return self
    }
}

extension URL: URLConvertible {

    public var url: URL? {
        return self
    }

    public var urlString: String {
        return absoluteString
    }
}

public extension URLQueryItem {

    var dictionary: [String: String] {
        return [name: value.emptyIfNil]
    }
}

private extension URLComponents {

    mutating func addPathSeparatorIfNeeded() {
        if !path.hasPrefix(.slash) {
            path = "\(String.slash)\(path)"
        }
    }
}

