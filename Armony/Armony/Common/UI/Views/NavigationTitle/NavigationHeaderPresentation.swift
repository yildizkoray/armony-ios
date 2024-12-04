//
//  NavigationHeaderPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 16.01.2022.
//

import UIKit

public struct NavigationHeaderPresentation {
    
    let title: NSAttributedString
    let subtitle: NSAttributedString?
    let insets: UIEdgeInsets

    public init(title: NSAttributedString,
                subtitle: NSAttributedString? = nil,
                insets: UIEdgeInsets = .init(horizontal: 16, vertical: .zero)) {
        self.title = title
        self.subtitle = subtitle
        self.insets = insets
    }
}
