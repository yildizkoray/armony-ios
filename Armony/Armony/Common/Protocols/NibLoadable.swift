//
//  NibView.swift
//  Armony
//
//  Created by Koray Yıldız on 23.08.2021.
//

import UIKit

protocol NibLoadable {
    static var nib: UINib { get }
}

extension NibLoadable where Self: UIView {

    static var nib: UINib {
        let nibName = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: nibName, bundle: bundle)
    }

    func initFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            preconditionFailure("Unable to instantiate nib name \(self)")
        }
        addSubviewAndConstraintsToEdges(view)
    }
}
