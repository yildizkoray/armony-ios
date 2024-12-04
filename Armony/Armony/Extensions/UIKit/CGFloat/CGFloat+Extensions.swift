//
//  CGFloat+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 21.11.2021.
//

import struct UIKit.CGFloat

public extension CGFloat {

    static var max: CGFloat {
        return .greatestFiniteMagnitude
    }

    static var min: CGFloat {
        return .leastNormalMagnitude
    }
}
