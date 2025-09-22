//
//  SocketResponseDecoder.swift
//  Armony
//
//  Created by Koray Yildiz on 29.07.23.
//

import Foundation

protocol SocketResponseDecoding {
    func decode<R: APIResponse>(response: String, for type: R.Type) throws -> R
}

final class SocketResponseDecoder: SocketResponseDecoding {

    private enum DecoderError: Error {
        case invalidData
    }

    static let shared = SocketResponseDecoder()

    private lazy var decoder = JSONDecoder()

    func decode<R>(response: String, for type: R.Type) throws -> R where R : APIResponse {
        guard let data = response.data(using: .utf8) else {
            throw SocketResponseDecoder.DecoderError.invalidData
        }

        /// Throw  API Error object
        let error = try JSONDecoder().decode(RestErrorResponse.self, from: data)
        try error.throwErrorIfFailure()

        let response = try decoder.decode(R.self, from: data)
        try response.throwErrorIfFailure()
        return response
    }
}
