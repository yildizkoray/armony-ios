//
//  HTTPTask.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation
import Alamofire

/**
 * HTTPTask Protocol
 *
 * A protocol that defines the structure for HTTP network tasks in the Armony app.
 * This protocol provides a standardized way to configure HTTP requests with
 * all necessary components like headers, body parameters, URL query items, and encoding.
 *
 * The protocol uses Alamofire for networking and integrates with RemoteConfigService
 * for dynamic configuration of API endpoints and versions.
 *
 * ## Usage Example:
 * ```swift
 * struct GetUserTask: HTTPTask {
 *     let userId: String
 *     
 *     var method: HTTPMethod { return .get }
 *     var path: String { return "/users/\(userId)" }
 *     
 *     var additionalHeader: [String: String] {
 *         return ["Authorization": "Bearer \(token)"]
 *     }
 * }
 * ```
 */
public protocol HTTPTask: CustomStringConvertible {
    
    /// Additional HTTP headers to include in the request
    var additionalHeader: [String: String] { get }
    
    /// Request body parameters (for POST, PUT requests)
    var body: Parameters? { get }
    
    /// HTTP method for the request (GET, POST, PUT, DELETE, etc.)
    var method: HTTPMethod { get }
    
    /// API endpoint path (e.g., "/users", "/posts/123")
    var path: String { get }
    
    /// URL query parameters to append to the request URL
    var urlQueryItems: [URLQueryItem]? { get }
    
    /// Parameter encoding strategy for the request
    var encoding: ParameterEncoding { get }
    
    /// API version string (e.g., "v1", "v2")
    var apiVersion: String { get }
    
    /// API host domain (e.g., "api.example.com")
    var host: String { get }
}

/**
 * Default implementations for HTTPTask protocol
 *
 * Provides sensible defaults for common HTTP task configurations.
 * These defaults can be overridden by conforming types when needed.
 */
public extension HTTPTask {

    /**
     * Default additional headers
     *
     * Returns an empty dictionary by default. Override this property
     * to add custom headers like authentication tokens or content types.
     *
     * ## Example:
     * ```swift
     * var additionalHeader: [String: String] {
     *     return ["Authorization": "Bearer \(authToken)"]
     * }
     * ```
     */
    var additionalHeader: [String: String] {
        return .empty
    }

    /**
     * Default request body
     *
     * Returns nil by default, meaning no body will be sent.
     * Override this property for POST/PUT requests that need to send data.
     *
     * ## Example:
     * ```swift
     * var body: Parameters? {
     *     return ["name": userName, "email": userEmail]
     * }
     * ```
     */
    var body: Parameters? {
        return nil
    }

    /**
     * Default description for debugging
     *
     * Returns the type name of the conforming task for easy identification
     * in logs and debugging output.
     */
    var description: String {
        return String(describing: type(of: self))
    }

    /**
     * Default parameter encoding strategy
     *
     * Automatically selects the appropriate encoding based on the HTTP method:
     * - POST/PUT requests use JSON encoding
     * - Other methods use URL encoding
     *
     * Override this property to use custom encoding strategies.
     */
    var encoding: ParameterEncoding {
        switch method {
        case .post, .put:
            return JSONEncoding.default

        default:
            return URLEncoding.default
        }
    }

    /**
     * Default URL query items
     *
     * Returns nil by default, meaning no query parameters will be added.
     * Override this property to add query parameters to the request URL.
     *
     * ## Example:
     * ```swift
     * var urlQueryItems: [URLQueryItem]? {
     *     return [URLQueryItem(name: "page", value: "\(pageNumber)")]
     * }
     * ```
     */
    var urlQueryItems: [URLQueryItem]? {
        return nil
    }

    /**
     * API version from remote configuration
     *
     * Retrieves the current API version from RemoteConfigService.
     * This allows for dynamic API version management without app updates.
     */
    var apiVersion: String {
        return RemoteConfigService.shared[.apiVersion]
    }

    /**
     * API host from remote configuration
     *
     * Retrieves the current API host from RemoteConfigService.
     * This allows for dynamic endpoint management (e.g., switching between
     * development, staging, and production environments).
     */
    var host: String {
        return RemoteConfigService.shared[.apiHost]
    }

    /**
     * Constructs the complete URL for the HTTP request
     *
     * Builds a URL by combining the scheme, host, API version, path, and query items.
     * Uses RemoteConfigService for dynamic configuration of scheme and host.
     *
     * ## URL Structure:
     * `{scheme}://{host}/{apiVersion}{path}?{queryItems}`
     *
     * ## Example:
     * ```
     * https://api.armony.com/v1/users/123?page=1
     * ```
     *
     * - Returns: A complete URL for the HTTP request
     * - Throws: URL construction errors if the components are invalid
     */
    func asURL() throws -> URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = RemoteConfigService.shared[.apiScheme]
        urlComponents.host = host
        urlComponents.path = "/\(apiVersion)\(path)"
        urlComponents.queryItems = urlQueryItems

        return try urlComponents.asURL()
    }
}
