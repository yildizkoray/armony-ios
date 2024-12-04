//
//  HTTPUploadTask.swift
//  Armony
//
//  Created by Koray Yıldız on 03.11.22.
//

import Foundation

public protocol HTTPUploadTask: HTTPTask {
    var files: [FormData] { get }
}
