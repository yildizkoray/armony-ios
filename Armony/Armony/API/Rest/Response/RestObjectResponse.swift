//
//  RestObjectResponse.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

/// Concrete implementation of `RestResponse` for single object data types.
/// 
/// This struct provides a standardized way to handle REST API responses that return
/// single decodable objects. It automatically implements the `RestResponse` protocol
/// requirements for object-based data.
/// 
/// - Generic Parameter `T`: The type of the object, must conform to `Decodable`
struct RestObjectResponse<T: Decodable>: RestResponse {
    
    /// The data type is the generic type T (single object)
    typealias Data = T

    /// The decodable object from the API response
    var data: Data
    
    /// Optional pagination metadata
    var metadata: RestResponseMeta?
    
    /// Optional error information from the API response
    var error: APIError?
}
