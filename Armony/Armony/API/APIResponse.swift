//
//  APIResponse.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

/// Base protocol for all API responses in the application.
/// 
/// Provides standardized error handling and success state checking for API responses.
/// All response types should conform to this protocol to ensure consistent error handling.
protocol APIResponse: Decodable {
    
    /// Optional API error information. Contains details about what went wrong if the request failed.
    /// See `APIError` for the structure of error information including code, description, and status.
    var error: APIError? { get }
    
    /// Indicates whether the API request was successful.
    /// Returns true when there is no error, false otherwise.
    var isSuccess: Bool { get }
}

extension APIResponse {

    /// Default implementation that checks if the response was successful.
    /// Returns true if error is nil, false otherwise.
    var isSuccess: Bool {
        error.isNil
    }

    /// Throws the API error if the response indicates failure.
    /// 
    /// This method logs the error to Firebase Crashlytics for monitoring and debugging,
    /// then throws the error to allow proper error handling in calling code.
    /// 
    /// - Throws: `APIError` if the response contains an error
    func throwErrorIfFailure() throws {
        if !isSuccess {
            FirebaseCrashlyticsLogger.shared.log(error: error)
            throw error!
        }
    }
}
