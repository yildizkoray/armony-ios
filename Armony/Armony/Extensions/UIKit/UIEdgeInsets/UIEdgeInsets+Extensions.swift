//
//  UIEdgeInsets+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 16.09.2021.
//

import UIKit

public extension UIEdgeInsets {

    init(edges: AppTheme.Spacing) {
        self.init(edges: edges.rawValue)
    }

    init(edges: CGFloat) {
        self.init(horizontal: edges, vertical: edges)
    }

    init(horizontal: AppTheme.Spacing, vertical: AppTheme.Spacing) {
        self.init(horizontal: horizontal.rawValue, vertical: vertical.rawValue)
    }

    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    var negated: UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }

    mutating func negate() {
        self = negated
    }

    var horizontal: CGFloat {
        return left + right
    }

    var vertical: CGFloat {
        return top + bottom
    }
}
