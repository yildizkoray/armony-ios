//
//  Service.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation

protocol Service {

    associatedtype Backend: API

    init(backend: Backend)

    func execute<R: APIResponse>(task operataion: Backend.Operation, type: R.Type) async throws -> R
    func execute<R: APIResponse>(
        task operataion: Backend.Operation,
        type: R.Type,
        completion: @escaping Callback<NetworkResult<R>>
    )

    func upload<R: APIResponse>(task operataion: Backend.UploadOperation, type: R.Type) async throws -> R
    func upload<R: APIResponse>(
        task operataion: Backend.UploadOperation,
        type: R.Type,
        completion: @escaping Callback<NetworkResult<R>>
    )

    func load<R: APIResponse>(from jsonString: String, type: R.Type) throws -> R
}
