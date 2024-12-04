//
//  DefaultRepresentation.swift
//  Armony
//
//  Created by KORAY YILDIZ on 03/07/2024.
//

import Foundation

protocol DefaultRepresentation {
    associatedtype Value

    static var defaultValue: Value { get }
}

@propertyWrapper
struct DefaultDecodable<T: DefaultRepresentation>: Decodable where T.Value: Decodable {
    let wrappedValue: T.Value

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(T.Value.self)
    }

    init() {
        wrappedValue = T.defaultValue
    }
}

extension KeyedDecodingContainer {
    func decode<D>(_ type: DefaultDecodable<D>.Type,
                   forKey key: Key) throws -> DefaultDecodable<D> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

protocol EmptyInitializable {
    init()
}

struct EmptyDefault<Value: EmptyInitializable>: DefaultRepresentation {
    static var defaultValue: Value {
        .init()
    }
}

extension Array: EmptyInitializable {}
extension String: EmptyInitializable {}

