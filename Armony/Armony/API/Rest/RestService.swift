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
        operations[operataion.description]?.cancel()
        guard internetConnectionService.isConnected else {
            FirebaseCrashlyticsLogger.shared.log(exception: .init(name: "RestService", reason: "internet is not connected"))
            throw APIError.network
        }
        
        do {
            let dataRequest = try? backend.execute(operation: operataion)
            addOperation(key: operataion.description, value: dataRequest)
            return try await handleExecution(for: dataRequest, type: type)
        }
    }

//    MARK: - Upload Operations
    func upload<R>(task operataion: RestAPI.UploadOperation, type: R.Type) async throws -> R where R : APIResponse {
        operations[operataion.description]?.cancel()
        guard internetConnectionService.isConnected else {
            FirebaseCrashlyticsLogger.shared.log(exception: .init(name: "RestService", reason: "internet is not connected"))
            throw APIError.network
        }
        
        do {
            let dataRequest = try? backend.upload(operation: operataion)
            addOperation(key: operataion.description, value: dataRequest)
            return try await handleExecution(for: dataRequest, type: type)
        }
    }
    
    
    private func handleExecution<R: APIResponse>(for executable: RestAPI.Executable?, type: R.Type) async throws -> R where R : APIResponse {
        do {
            /// Throw operation create error
            guard let dataRequest = executable else {
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
