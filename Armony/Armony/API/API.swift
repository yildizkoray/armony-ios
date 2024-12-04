//
//  API.swift
//  Armony
//
//  Created by Koray Yıldız on 27.08.2021.
//

import Foundation
import Alamofire

protocol API {
    
    associatedtype Operation
    associatedtype UploadOperation
    associatedtype Executable

    func execute(operation: Operation) throws -> Executable
    func upload(operation: UploadOperation) throws -> Executable
}
