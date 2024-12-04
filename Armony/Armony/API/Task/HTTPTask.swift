//
//  HTTPTask.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation
import Alamofire

public protocol HTTPTask: CustomStringConvertible {
    var additionalHeader: [String: String] { get }
    var body: Parameters? { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var urlQueryItems: [URLQueryItem]? { get }
    var encoding: ParameterEncoding { get }
    var apiVersion: String { get }
    var host: String { get }
}

public extension HTTPTask {

    var additionalHeader: [String: String] {
        return .empty
    }

    var body: Parameters? {
        return nil
    }

    var description: String {
        return String(describing: type(of: self))
    }

    var encoding: ParameterEncoding {
        switch method {
        case .post, .put:
            return JSONEncoding.default

        default:
            return URLEncoding.default
        }
    }

    var urlQueryItems: [URLQueryItem]? {
        return nil
    }

    var apiVersion: String {
        return RemoteConfigService.shared[.apiVersion]
    }

    var host: String {
        return RemoteConfigService.shared[.apiHost]
    }

    func asURL() throws -> URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = RemoteConfigService.shared[.apiScheme]
        urlComponents.host = host
        urlComponents.path = "/\(apiVersion)\(path)"
        urlComponents.queryItems = urlQueryItems

        return try urlComponents.asURL()
    }
}
