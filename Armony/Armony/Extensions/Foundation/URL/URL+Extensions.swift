//
//  URL+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 14.11.2021.
//

import Foundation
import UIKit

extension URL {
    static let localhost = URL(staticString: "http://localhost")

    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }
        self = url
    }

    static func randomImage(size: Int) -> URL {
        return URL(string: "https://picsum.photos/\(size)")!
    }

    var deeplink: Deeplink {
        return Deeplink(stringLiteral: absoluteString)
    }
}

extension URLRequest {
    mutating func addAuthentication(authenticator: AuthenticationService) {
        for (key, value) in authenticator.additionalHTTPHeaders where value.isNotEmpty {
            setValue(value, forHTTPHeaderField: key)
        }
    }
}
