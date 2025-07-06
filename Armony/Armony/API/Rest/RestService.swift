//
//  RestService.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation
import Alamofire

/// Concrete implementation of `Service` protocol for REST API operations.
/// 
/// This class provides the actual implementation for making REST API calls, handling
/// network requests, managing operations, and processing responses. It uses `RestAPI`
/// to create executable network requests and Alamofire for network operations.
/// 
/// ## Architecture:
/// - **RestService**: Orchestrates API calls and handles responses
/// - **RestAPI**: Creates executable `DataRequest` objects from `HTTPTask` operations
/// - **RestAPIMiddleware**: Handles authentication, headers, and token refresh
/// - **Alamofire**: Performs the actual network communication
/// 
/// ## Usage Examples:
/// ```swift
/// // Initialize the service with RestAPI
/// let restAPI = RestAPI.factory()
/// let restService = RestService(backend: restAPI)
/// 
/// // Execute a regular API call
/// do {
///     let userResponse: RestObjectResponse<User> = try await restService.execute(
///         task: .getUserProfile(userId: "123"),
///         type: RestObjectResponse<User>.self
///     )
///     let user = userResponse.data
/// } catch {
///     // Handle error
/// }
/// 
/// // Upload a file
/// do {
///     let uploadResponse: RestObjectResponse<UploadResult> = try await restService.upload(
///         task: .uploadImage(imageData: imageData),
///         type: RestObjectResponse<UploadResult>.self
///     )
///     let result = uploadResponse.data
/// } catch {
///     // Handle error
/// }
/// 
/// // Load from JSON string
/// let jsonString = "{\"data\": {...}, \"error\": null}"
/// let response: RestObjectResponse<User> = try restService.load(
///     from: jsonString,
///     type: RestObjectResponse<User>.self
/// )
/// 
/// // Load from JSON file
/// let response: RestObjectResponse<User> = restService.load(
///     fromJSONFile: "user_profile",
///     type: RestObjectResponse<User>.self
/// )
/// ```
class RestService: Service {

    /// The backend type is RestAPI which creates executable DataRequest objects
    typealias Backend = RestAPI

    /// The RestAPI instance that creates executable network requests
    private let backend: RestAPI
    
    /// Dictionary to track active operations for cancellation
    private var operations: [String: DataRequest]
    
    /// Service to check internet connectivity
    private let internetConnectionService: InternetConnectionService = .shared

    /// Concurrent queue for safely adding operations
    private let addOperationQueue = DispatchQueue(label: "addOperationQueue", attributes: .concurrent)

    /// Initializes the service with a RestAPI backend
    /// - Parameter backend: The RestAPI instance that creates executable network requests
    required init(backend: RestAPI) {
        self.backend = backend
        self.operations = [String: DataRequest]()
    }
	
    /// Safely adds an operation to the operations dictionary using concurrent queue
    /// - Parameters:
    ///   - key: The operation identifier
    ///   - value: The Alamofire DataRequest to store
    private func addOperation(key: String, value: DataRequest?) {
        addOperationQueue.async(flags: .barrier) {
            self.operations[key] = value
        }
    }

    // MARK: - Execute Operations
    
    /// Executes a regular REST API operation and returns the response.
    /// 
    /// This method uses RestAPI to create an executable DataRequest from the operation,
    /// cancels any existing operation with the same description, checks internet connectivity,
    /// and handles the network request.
    /// 
    /// - Parameters:
    ///   - operation: The REST API operation to execute
    ///   - type: The expected response type that conforms to `APIResponse`
    /// - Returns: The API response of the specified type
    /// - Throws: Network errors, API errors, or connectivity errors
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

    // MARK: - Upload Operations
    
    /// Uploads data using a REST API upload operation and returns the response.
    /// 
    /// This method uses RestAPI to create an executable DataRequest from the upload operation,
    /// cancels any existing operation with the same description, checks internet connectivity,
    /// and handles the file upload request.
    /// 
    /// - Parameters:
    ///   - operation: The upload operation to execute
    ///   - type: The expected response type that conforms to `APIResponse`
    /// - Returns: The API response of the specified type
    /// - Throws: Network errors, API errors, or connectivity errors
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
    
    
    /// Handles the execution of network requests and response processing.
    /// 
    /// This private method processes the network response, handles errors,
    /// checks for token expiration, and decodes the response data.
    /// 
    /// - Parameters:
    ///   - executable: The executable network request (DataRequest)
    ///   - type: The expected response type
    /// - Returns: The decoded API response
    /// - Throws: Various API and network errors
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

    // MARK: - Local Provider
    
    /// Loads and decodes an API response from a JSON string.
    /// 
    /// - Parameters:
    ///   - jsonString: The JSON string to decode
    ///   - type: The expected response type that conforms to `APIResponse`
    /// - Returns: The decoded API response
    /// - Throws: Decoding errors if the JSON cannot be parsed
    func load<R>(from jsonString: String, type: R.Type) throws -> R where R : APIResponse {
        let data = jsonString.data(using: .utf8)
        guard let data = data else {
            throw APIError.noData
        }
        let decodedObject = try JSONDecoder().decode(R.self, from: data)
        return decodedObject
    }

    /// Loads and decodes an API response from a JSON file in the app bundle.
    /// 
    /// - Parameter fileName: The name of the JSON file (without extension)
    /// - Returns: The decoded API response
    func load<R>(fromJSONFile fileName : String, type: R.Type) -> R where R : APIResponse {
        let filePath = Bundle.main.url(forResource: fileName, withExtension: ".json")
        let data = try! Data(contentsOf: filePath!, options: .alwaysMapped)
        let decodedObject = try! JSONDecoder().decode(R.self, from: data)
        return decodedObject
    }
    
    /// Cancels all active operations and clears the operations dictionary.
    private func cancelAll() {
        operations.values.forEach {
            $0.cancel()
        }
        operations.removeAll(keepingCapacity: false)
    }

    /// Deinitializer that cancels all operations when the service is deallocated.
    deinit {
        cancelAll()
    }
}
