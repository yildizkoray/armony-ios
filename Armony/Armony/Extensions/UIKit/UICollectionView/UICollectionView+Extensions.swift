//
//  UICollectionView+.swift
//  Armony
//
//  Created by Koray Yıldız on 8.09.2021.
//

import UIKit

public typealias SupplemetaryView = (viewClass: AnyClass, kind: UICollectionView.SupplementaryKind)

public extension UICollectionView {

    enum SupplementaryKind: String {
        case header
        case footer

        var kind: String {
            switch self {
            case .header:
                return UICollectionView.elementKindSectionHeader

            case .footer:
                return UICollectionView.elementKindSectionFooter
            }
        }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(identifier: String, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }

    func registerCells(for types: [UICollectionViewCell.Type]) {
        types.forEach {
            register($0.nib, forCellWithReuseIdentifier: String(describing: $0))
        }
    }

    func registerCells(classes: [UICollectionViewCell.Type]) {
        classes.forEach {
            register($0, forCellWithReuseIdentifier: String(describing: $0))
        }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(identifier: identifier, for: indexPath) as! T
    }

    func deleteItems(_ indexPaths: [IndexPath], completion: @escaping VoidCallback) {
        transaction(closure: {
            self.deleteItems(at: indexPaths)
        }, completion: completion)
    }

    func insertItems(_ indexPaths: [IndexPath], completion: @escaping VoidCallback) {
        transaction(closure: {
            self.insertItems(at: indexPaths)
        }, completion: completion)
    }

    func insertSections(_ sections: IndexSet, completion: @escaping VoidCallback) {
        transaction(closure: {
            self.insertSections(sections)
        }, completion: completion)
    }

    func register(supplemetaries: [SupplemetaryView]) {
        supplemetaries.forEach {
            register(
                $0.viewClass,
                forSupplementaryViewOfKind: $0.kind.kind,
                withReuseIdentifier: String(describing: $0.viewClass)
            )
        }
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        kind: UICollectionView.SupplementaryKind,
        for indexPath: IndexPath
    ) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableSupplementaryView(ofKind: kind.kind, withReuseIdentifier: identifier, for: indexPath) as! T
    }

    func isLastItem(indexPath: IndexPath) -> Bool {
        return numberOfItems(inSection: indexPath.section) == indexPath.row + 1
    }
}

public func transaction(closure: VoidCallback, completion: @escaping VoidCallback) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    closure()
    CATransaction.commit()
}

