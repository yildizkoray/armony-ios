//
//  RestArrayResponse.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

/// Concrete implementation of `RestResponse` for array data types.
/// 
/// This struct provides a standardized way to handle REST API responses that return
/// arrays of decodable objects. It automatically implements the `RestResponse` protocol
/// requirements for array-based data.
/// 
/// - Generic Parameter `T`: The type of objects in the array, must conform to `Decodable`
struct RestArrayResponse<T: Decodable>: RestResponse {

    /// The data type is an array of the generic type T
    typealias Data = [T]

    /// The array of decodable objects from the API response
    var data: Data
    
    /// Optional pagination metadata
    var metadata: RestResponseMeta?
    
    /// Optional error information from the API response
    var error: APIError?
}
