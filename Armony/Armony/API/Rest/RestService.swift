//
//  RestService.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation
import Alamofire

class RestService: Service {

    typealias Backend = RestAPI

    private let backend: RestAPI
    private var operations: [String: DataRequest]
    private let internetConnectionService: InternetConnectionService = .shared

    private let addOperationQueue = DispatchQueue(label: "addOperationQueue", attributes: .concurrent)

    private var isNewAsyncAwaitEnabled: Bool {
        return RemoteConfigService.shared[.isNewAsyncAwaitEnabled]
    }

    required init(backend: RestAPI) {
        self.backend = backend
        self.operations = [String: DataRequest]()
    }
	
    private func addOperation(key: String, value: DataRequest?) {
        addOperationQueue.async(flags: .barrier) {
            self.operations[key] = value
        }
    }

//    MARK: - Execute Operations
    func execute<R>(task operataion: RestAPI.Operation, type: R.Type) async throws -> R where R : APIResponse {
        guard isNewAsyncAwaitEnabled else {
            return try await executeWithCheckedThrowingContinuation(task: operataion, type: type)
        }

        do {
            operations[operataion.description]?.cancel()
            guard internetConnectionService.isConnected else {
                FirebaseCrashlyticsLogger.shared.log(exception: .init(name: "RestService", reason: "internet is not connected"))
                throw APIError.network
            }

            let dataRequest = try? backend.execute(operation: operataion)
            addOperation(key: operataion.description, value: dataRequest)

            /// Throw operation create error
            guard let dataRequest = dataRequest else {
                throw APIError.operationCreate
            }

            /// Async network request
            let response = await dataRequest.serializingData().response

            /// Throw empty data error
            guard let data = response.data else {
                throw APIError.noData
            }

            /// Check for login-registration flow
            if response.response?.statusCode == NSHTTPURLResponseTokenExpiredStatusCode {
                let error = try JSONDecoder().decode(RestErrorResponse.self, from: data)
                try error.throwErrorIfFailure()
            }

            if let error = response.error {
                FirebaseCrashlyticsLogger.shared.log(error: error)
                throw error
            }

            /// Throw  API Error object
            let error = try JSONDecoder().decode(RestErrorResponse.self, from: data)
            try error.throwErrorIfFailure()

            /// Return decoded data
            let decodedObject = try JSONDecoder().decode(type, from: data)
            return decodedObject
        }
    }

    private func executeWithCheckedThrowingContinuation<R>(task operataion: RestAPI.Operation, type: R.Type) async throws -> R where R : APIResponse {
        return try await withCheckedThrowingContinuation({ continuation in
            execute(task: operataion, type: type) { result in
                switch result {
                case .success(let data):
                    safeSync {
                        continuation.resume(returning: data)
                    }

                case .failure(let error):
                    continuation.resume(throwing: error)
                    FirebaseCrashlyticsLogger.shared.log(error: error)
                }
            }
        })
    }

    func execute<R>(task operataion: HTTPTask, type: R.Type, completion: @escaping Callback<NetworkResult<R>>) where R : APIResponse {
        operations[operataion.description]?.cancel()
        guard internetConnectionService.isConnected else {
            completion(.failure(.network))
            FirebaseCrashlyticsLogger.shared.log(exception: .init(name: "RestService", reason: "internet is not connected"))
            return
        }

        do {
            let dataRequest = try backend.execute(operation: operataion)
            addOperation(key: operataion.description, value: dataRequest)
            handleExecution(for: dataRequest, type: R.self, completion: completion)
        } catch let error {
            debugPrint(error)
            completion(.failure(.operationCreate))
        }
    }

//    MARK: - Upload Operations
    func upload<R>(task operataion: RestAPI.UploadOperation, type: R.Type) async throws -> R where R : APIResponse {
        return try await withCheckedThrowingContinuation({ continuation in
            upload(task: operataion, type: type) { result in
                switch result {
                case .success(let data):
                    safeSync {
                        continuation.resume(returning: data)
                    }

                case .failure(let error):
                    continuation.resume(throwing: error)
                    FirebaseCrashlyticsLogger.shared.log(error: error)
                }
            }
        })
    }

    func upload<R>(task operataion: RestAPI.UploadOperation, type: R.Type, completion: @escaping Callback<NetworkResult<R>>) where R : APIResponse {
        operations[operataion.description]?.cancel()
        guard internetConnectionService.isConnected else {
            completion(.failure(.network))
            return
        }

        do {
            let dataRequest = try backend.upload(operation: operataion)
            addOperation(key: operataion.description, value: dataRequest)
            handleExecution(for: dataRequest, type: R.self, completion: completion)
        } catch let error {
            debugPrint(error)
            completion(.failure(.operationCreate))
        }
    }

    private func handleExecution<R: APIResponse>(for executable: RestAPI.Executable, type: R.Type, completion: @escaping Callback<NetworkResult<R>>) {
        executable.response { response in
            switch response.result {
            case .success(let data):
                do {
                    guard let data = data else {
                        completion(.failure(.noData))
                        return
                    }

                    /// Throw  API Error object
                    let error = try JSONDecoder().decode(RestErrorResponse.self, from: data)
                    try error.throwErrorIfFailure()

                    /// Return decoded data
                    let decodedObject = try JSONDecoder().decode(type, from: data)
                    try decodedObject.throwErrorIfFailure()
                    completion(.success(decodedObject))

                } catch let error {
                    if let apiError = error.api {
                        completion(.failure(apiError))
                    }
                    else {
                        debugPrint(error)
                        completion(.failure(.decoding))
                    }
                }
            case .failure(let error):
                guard let afError = error.asAFError,
                      !(afError.isExplicitlyCancelledError ||
                        afError.isSessionDeinitializedError) else {
                    return
                }
                let statusCode = response.response?.statusCode
                let data = response.data

                if statusCode == NSHTTPURLResponseTokenExpiredStatusCode,
                   let data = data {
                    do {
                        let error = try JSONDecoder().decode(RestErrorResponse.self, from: data)
                        try error.throwErrorIfFailure()
                    }
                    catch let error {
                        if let decodedError = error.api {
                            completion(.failure(decodedError))
                            return
                        }
                    }
                }
                completion(.failure(.network))
            }
        }
    }

//    MARK: - Local Provider
    func load<R>(from jsonString: String, type: R.Type) throws -> R where R : APIResponse {
        let data = jsonString.data(using: .utf8)
        guard let data = data else {
            throw APIError.noData
        }
        let decodedObject = try JSONDecoder().decode(R.self, from: data)
        return decodedObject
    }

    func load<R>(fromJSONFile fileName : String, type: R.Type) -> R where R : APIResponse {
        let filePath = Bundle.main.url(forResource: fileName, withExtension: ".json")
        let data = try! Data(contentsOf: filePath!, options: .alwaysMapped)
        let decodedObject = try! JSONDecoder().decode(R.self, from: data)
        return decodedObject
    }
    
    private func cancelAll() {
        operations.values.forEach {
            $0.cancel()
        }
        operations.removeAll(keepingCapacity: false)
    }

    deinit {
        cancelAll()
    }
}
