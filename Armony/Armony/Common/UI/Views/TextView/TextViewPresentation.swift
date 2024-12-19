//
//  TextViewPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 16.07.22.
//

import Foundation

struct TextViewPresentation {
    let placeholder: String
    let numberOfMinimumChar: Int
    let numberOfMaximumChar: Int

    // MARK: - EMPTY
    static let empty = TextViewPresentation(placeholder: .empty, numberOfMinimumChar: .zero, numberOfMaximumChar: 250)

    static let feedback = TextViewPresentation(
        placeholder: "Please enter description. Minimum 15 character",
        numberOfMinimumChar: 15,
        numberOfMaximumChar: 250
    )
    
    static let description = TextViewPresentation(
        placeholder: String("TextViewDescription", table: .placeAdvert),
        numberOfMinimumChar: .zero,
        numberOfMaximumChar: 500
    )
}
