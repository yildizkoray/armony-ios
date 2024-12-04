//
//  APIError.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

public struct APIError: Error, Decodable {
    
    public let code: Int?
    public let description: String
    public let status: Int

    public init(code: Int = .zero, description: String) {
        self.code = code
        self.description = description
        self.status = NSNotFound
    }
    
    private static var errorTitle = String("API.ERROR", table: .common)
    

    // TODO: - Localizable
    public static let emptyData = APIError(description: errorTitle)
    public static let noData = APIError(description: errorTitle)
    public static let operationCreate = APIError(description: errorTitle)
    public static let decoding = APIError(description: errorTitle)
    public static let network = APIError(description: errorTitle)
}
