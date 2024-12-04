//
//  Settings.swift
//  Armony
//
//  Created by Koray Yildiz on 27.05.22.
//

import Foundation

struct Setting: Decodable {
    let id: Int
    let deeplink: Deeplink
    let accessoryImageName: String
    let isVisible: Bool
    let title: String
}
