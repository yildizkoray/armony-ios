//
//  ActivityIndicator+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 15.11.2021.
//

import UIKit

extension UIActivityIndicatorView {
    
    static func create(color: UIColor, style: UIActivityIndicatorView.Style = .medium) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.color = color
        return view
    }
}
