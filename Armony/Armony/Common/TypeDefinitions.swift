//
//  TypeDefinitions.swift
//  Armony
//
//  Created by Koray Yildiz on 07.06.22.
//

import Foundation

public typealias VoidCallback = () -> Void
public typealias Callback<T> = (_: T) -> Void
public typealias EmptyResult = Swift.Result<(), Error>

// MARK: - EmptyReponse
struct EmptyResponse: Decodable { }

public func safeSync(execute: VoidCallback) {
    if Thread.isMainThread {
        execute()
    }
    else {
        DispatchQueue.main.sync(execute: execute)
    }
}
