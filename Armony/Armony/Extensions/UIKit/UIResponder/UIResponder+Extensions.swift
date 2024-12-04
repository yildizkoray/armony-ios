//
//  UIResponder+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 8.09.2021.
//

import UIKit.UIResponder

public extension UIResponder {

    class var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}
