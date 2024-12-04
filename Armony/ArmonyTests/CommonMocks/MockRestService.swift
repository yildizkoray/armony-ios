//
//  MockRestService.swift
//  ArmonyTests
//
//  Created by Koray Yildiz on 15.07.22.
//

@testable import Armony
import Foundation

final class MockRestService: RestService {

    static var shared: MockRestService = MockRestService(backend: .factory())

    var mockResult: NetworkResult<APIResponse>? = nil

    override func execute<R>(task operataion: HTTPTask,
                             type: R.Type,
                             completion: @escaping Callback<NetworkResult<R>>) where R : APIResponse {
        switch mockResult {
        case .success(let response):
            completion(.success(response as! R))

        case .failure(let error):
            completion(.failure(error))
        case .none:
            break
        }
    }

    override func load<R>(fromJSONFile fileName: String, type: R.Type) -> R where R : APIResponse {
        let bundle = Bundle(for: MockRestService.self)
        let filePath = bundle.url(forResource: fileName, withExtension: ".json")
        let data = try! Data(contentsOf: filePath!, options: .alwaysMapped)
        let decodedObject = try! JSONDecoder().decode(R.self, from: data)
        return decodedObject
    }
}


