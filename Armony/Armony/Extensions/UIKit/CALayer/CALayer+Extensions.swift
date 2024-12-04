//
//  CALayer+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 7.11.2021.
//

import UIKit

public extension CALayer {

    static var allCorners: CACornerMask {
        return [
            .layerMinXMinYCorner, .layerMaxXMinYCorner,
            .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        ]
    }

    static var topCorners: CACornerMask {
        return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    static var bottomCorners: CACornerMask {
        return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    static var leftCorners: CACornerMask {
        return [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    static var rightCorners: CACornerMask {
        return [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}
