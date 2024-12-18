//
//  MusicGenresPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 24.01.2022.
//

import Foundation
import UIKit

private struct Constants {
    static let titleHorizontalMargins: CGFloat = 32
    static let cellHeight: CGFloat = 26.0
}

public struct MusicGenresPresentation {
    let title: NSAttributedString
    let cellBorderColor: UIColor
    let separatorPresentation: GradientPresentation
    let items: [MusicGenreItemPresentation]
    let shouldAdjustCellHeight: Bool

    var cellHeight: CGFloat {
        return Constants.cellHeight
    }

    init(title: NSAttributedString = String("MusicGenre", table: .common).attributed(color: .white, font: .lightBody),
         cellBorderColor: UIColor,
         separator gradient: GradientPresentation = .separator,
         items: [MusicGenreItemPresentation],
         shouldAdjustCellHeight: Bool = false) {
        self.cellBorderColor = cellBorderColor
        self.title = title
        self.separatorPresentation = gradient
        self.items = items
        self.shouldAdjustCellHeight = shouldAdjustCellHeight
    }

    func cellWidth(at indexPath: IndexPath, containerHeight: CGFloat) -> CGFloat {
        return items[indexPath.row].title.width(for: containerHeight) + Constants.titleHorizontalMargins
    }

    // MARK: - EMPTY
    static let empty = MusicGenresPresentation(title: .empty, cellBorderColor: .clear, separator: .empty, items: .empty)
}
