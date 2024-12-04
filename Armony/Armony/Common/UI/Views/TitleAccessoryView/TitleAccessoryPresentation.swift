//
//  TitleAccessoryPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 23.12.22.
//

import Foundation

public struct TitleAccessoryPresentation {
    let title: NSAttributedString
    let accessoryImage: ImageSource

    init(title: NSAttributedString, accessoryImage: ImageSource) {
        self.title = title
        self.accessoryImage = accessoryImage
    }

    // MARK: - EMPTY
    static let empty = TitleAccessoryPresentation(title: .empty, accessoryImage: .url(.none))
}
