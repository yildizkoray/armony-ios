//
//  RestAPI.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation
import Alamofire

typealias NetworkResult<T> = Swift.Result<T, APIError>
public let NSHTTPURLResponseTokenExpiredStatusCode: Int = 401

final class RestAPI: API {

    typealias Executable = DataRequest
    typealias Operation = HTTPTask
    typealias UploadOperation = HTTPUploadTask

    private var connector: Session

    public lazy var acceptableStatusCodes: [Int] = {
        var acceptableStatusCodes = [Int]()
        acceptableStatusCodes.append(contentsOf: 200...299)
        acceptableStatusCodes.append(contentsOf: 400...499)

        acceptableStatusCodes.remove(element: NSHTTPURLResponseTokenExpiredStatusCode)
        return acceptableStatusCodes
    }()

    init(interceptor: RestAPIMiddleware) {
        self.connector = Session(additionalHeaders: HTTPHeaders(), interceptor: interceptor)
    }

    public class func factory() -> RestAPI {
        return RestAPI(interceptor: RestAPIMiddleware())
    }

    public func execute(operation: HTTPTask) throws -> DataRequest {
        return try connector.request(
            operation.asURL(),
            method: operation.method,
            parameters: operation.body,
            encoding: operation.encoding,
            headers: HTTPHeaders(operation.additionalHeader)).validate(statusCode: acceptableStatusCodes)
    }

    public func upload(operation: HTTPUploadTask) throws -> DataRequest {
        return try connector.upload(
            multipartFormData: { $0.append(operation: operation) },
            to: operation.asURL(),
            method: operation.method,
            headers: HTTPHeaders(operation.additionalHeader)
        )
        .validate(statusCode: acceptableStatusCodes)
    }
}

// MARK: Alamofire.Session
public extension Alamofire.Session {

    convenience init(additionalHeaders: HTTPHeaders, interceptor: RequestInterceptor) {

        var defaultHeaders = HTTPHeaders.default
        additionalHeaders.forEach {
            defaultHeaders.update($0)
        }

        // TODO: - Localizable
        defaultHeaders["Language"] = Locale.preferredLanguages.first?.components(separatedBy: String.hyphen).first
        defaultHeaders["Accept"] = "application/json"
        defaultHeaders["AppVersion"] = Bundle.main.version

        let configuration = URLSessionConfiguration.af.default
        configuration.headers = defaultHeaders

        self.init(configuration: configuration, interceptor: interceptor)
    }
}

// MARK: - Alamofire.MultipartFormData
public extension Alamofire.MultipartFormData {

    func append(operation: HTTPUploadTask) {
        operation.files.forEach { file in
            append(file.data, withName: file.key, fileName: file.name, mimeType: file.type.description)
        }
    }
}
