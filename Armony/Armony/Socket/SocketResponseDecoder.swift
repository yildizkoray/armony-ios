//
//  SocketResponseDecoder.swift
//  Armony
//
//  Created by Koray Yildiz on 29.07.23.
//

import Foundation

protocol SocketResponseDecoding {
    func decode<R: Decodable>(response: String, for type: R.Type) -> R?
}

final class SocketResponseDecoder: SocketResponseDecoding {

    private enum DecoderError: Error {
        case invalidData
    }

    static let shared = SocketResponseDecoder()

    private lazy var decoder = JSONDecoder()

    func decode<R>(response: String, for type: R.Type) -> R? where R : Decodable {
        do {
            guard let data = response.data(using: .utf8) else {
                throw SocketResponseDecoder.DecoderError.invalidData
            }

            let response = try decoder.decode(R.self, from: data)
            return response
        }
        catch let error {
            FirebaseCrashlyticsLogger.shared.log(error: error)
            return nil
        }
    }
}
