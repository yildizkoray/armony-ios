//
//  NSAttributedString+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 21.11.2021.
//

import UIKit

public extension NSAttributedString {

    static let empty = NSAttributedString()

    func width(for height: CGFloat) -> CGFloat {
        let rect = boundingRect(with: CGSize(width: .max, height: height),
                                options: [.usesLineFragmentOrigin],
                                context: nil)
        return ceil(rect.width)
    }
}
