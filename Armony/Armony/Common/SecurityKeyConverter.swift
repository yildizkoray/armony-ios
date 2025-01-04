//
//  SecurityKeyConverter.swift
//  Armony
//
//  Created by KORAY YILDIZ on 31/12/2024.
//

import Foundation
import Security

enum KeyConverterError: Error {
    case invalidPublicKey
    case conversionFailed
    case invalidPEMFormat
    case invalidBase64String
}

final class SecurityKeyConverter {
    
    /// Creates Data from a PEM formatted public key
    /// - Parameter pemKey: The PEM formatted public key string
    /// - Returns: The public key as Data
    /// - Throws: KeyConverterError if the PEM format is invalid
    static func createDataFromPEM(_ pemKey: String) throws -> Data {
        // Remove PEM headers and whitespace
        let cleanedPEM = pemKey
            .replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: String.empty)
            .replacingOccurrences(of: "-----END PUBLIC KEY-----", with: String.empty)
            .replacingOccurrences(of: String.newLine, with: String.empty)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Convert base64 to data
        guard let data = Data(base64Encoded: cleanedPEM) else {
            throw KeyConverterError.invalidPEMFormat
        }
        
        return data
    }
    
    /// Converts a public key to a secret key using Security framework
    /// - Parameter publicKey: The public key data to convert
    /// - Returns: The converted secret key data
    /// - Throws: KeyConverterError if conversion fails
    static func convertPublicKeyToSecretKey(_ publicKey: Data) throws -> SecKey {
        var error: Unmanaged<CFError>?
        
        guard let publicKey = SecKeyCreateWithData(publicKey as CFData,
                                                   [kSecAttrKeyType: kSecAttrKeyTypeRSA,
                                                   kSecAttrKeyClass: kSecAttrKeyClassPublic] as CFDictionary,
                                                   &error) else {
            throw KeyConverterError.invalidPublicKey
        }
        
        return publicKey
    }
}

