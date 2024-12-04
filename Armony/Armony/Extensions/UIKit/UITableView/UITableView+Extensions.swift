//
//  UITableView+Extensions.swift
//  Armony
//
//  Created by Koray Yildiz on 28.05.22.
//

import UIKit

extension UITableView {

    func registerCells(cells: [UITableViewCell.Type]) {
        cells.forEach {
            register($0.nib, forCellReuseIdentifier: String(describing: $0))
        }
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }

    func registerSectionHeaderFooters(for types: [UITableViewHeaderFooterView.Type]) {
        for type in types {
            register(type.nib, forHeaderFooterViewReuseIdentifier: String(describing: type))
        }
    }

    func registerSectionHeaderFooters(aClasses classes: [UITableViewHeaderFooterView.Type]) {
        for aClass in classes {
            register(aClass, forHeaderFooterViewReuseIdentifier: String(describing: aClass))
        }
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(identifier: String) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: identifier) as! T
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        return dequeueReusableHeaderFooterView(identifier: String(describing: T.self))
    }
}
