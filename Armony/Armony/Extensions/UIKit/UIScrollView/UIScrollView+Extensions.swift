//
//  UIScrollView+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 20.11.2023.
//

import UIKit

extension UIScrollView {

    struct Direction: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let horizontal = Direction(rawValue: 1 << 0)
        public static let vertical = Direction(rawValue: 1 << 1)
    }

    func scrollToTop(animated: Bool) {
        let newContentOffset = CGPoint(x: contentOffset.x, y: -contentInset.top)
        setContentOffset(newContentOffset, animated: animated)
    }


    var direction: Direction {
        var direction: Direction = []

        if bounds.height < contentSize.height {
            direction.formUnion(.vertical)
        }

        if bounds.width < contentSize.width {
            direction.formUnion(.horizontal)
        }

        return direction
    }
}
