//
//  Service.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

/// Protocol that defines the interface for API services.
/// 
/// This protocol provides a standardized way to interact with backend APIs through
/// different operations like regular API calls, file uploads, and JSON parsing.
/// Each service implementation should specify its API type that creates executable
/// network requests and provide implementations for the required methods.
/// 
/// - Associated Type `Backend`: The API implementation that creates executable network requests
protocol Service {

    /// The API implementation that creates executable network requests
    associatedtype Backend: API

    /// Initializes the service with a specific API implementation
    /// - Parameter backend: The API implementation that creates executable network requests
    init(backend: Backend)

    /// Executes a regular API operation and returns the response.
    /// 
    /// - Parameters:
    ///   - operation: The API operation to execute
    ///   - type: The expected response type that conforms to `APIResponse`
    /// - Returns: The API response of the specified type
    /// - Throws: Network errors, decoding errors, or API errors
    func execute<R: APIResponse>(task operataion: Backend.Operation, type: R.Type) async throws -> R

    /// Uploads data using an upload operation and returns the response.
    /// 
    /// - Parameters:
    ///   - operation: The upload operation to execute
    ///   - type: The expected response type that conforms to `APIResponse`
    /// - Returns: The API response of the specified type
    /// - Throws: Network errors, decoding errors, or API errors
    func upload<R: APIResponse>(task operataion: Backend.UploadOperation, type: R.Type) async throws -> R

    /// Loads and decodes an API response from a JSON string.
    /// 
    /// - Parameters:
    ///   - jsonString: The JSON string to decode
    ///   - type: The expected response type that conforms to `APIResponse`
    /// - Returns: The decoded API response
    /// - Throws: Decoding errors if the JSON cannot be parsed
    func load<R: APIResponse>(from jsonString: String, type: R.Type) throws -> R
}
