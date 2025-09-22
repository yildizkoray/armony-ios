//
//  RestResponse.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

/// Protocol that extends `APIResponse` to provide structure for REST API responses.
/// 
/// This protocol adds data and metadata support to the base API response structure.
/// It's used for responses that contain actual data payloads and optional pagination metadata.
protocol RestResponse: APIResponse {

    /// The type of data contained in this REST response
    associatedtype Data

    /// The main response data payload
    var data: Data { get }
    
    /// Optional metadata containing pagination information
    var metadata: RestResponseMeta? { get }
}

/// Metadata structure for REST API responses, typically used for pagination.
/// 
/// Contains information about the current page and whether there are more pages available.
struct RestResponseMeta: Codable {
    /// The current page number (1-based indexing)
    let page: Int
    
    /// Indicates whether there are more pages available after the current page
    let hasNext: Bool
}
