//
//  SkillsPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 8.10.2021.
//

import Foundation
import UIKit

public struct SkillsPresentation {
    
    let type: `Type`
    let title: NSAttributedString
    let separatorPresentation: GradientPresentation
    let skills: [SkillItemPresentation]

    init(type: `Type`,
         title: NSAttributedString = "Çaldığım Enstrümanlar".attributed(color: .white, font: .lightBody),
         separatorPresentation: GradientPresentation = .separator,
         skillTitleStyle skillTitleStylePresentation: TextAppearancePresentation,
         skills: [Skill]) {
        self.type = type
        self.title = title
        self.separatorPresentation = separatorPresentation
        self.skills = skills.lazy.map { SkillItemPresentation(style: skillTitleStylePresentation, skill: $0) }
    }

    private init() {
        type = .advert(imageViewContainerViewBorderColor: .armonyBlack)
        title = .empty
        separatorPresentation = .empty
        skills = .empty
    }

    func cellWidth(at indexPath: IndexPath) -> CGFloat {
        switch type {
        case .advert, .profile:
            return 56.0

        case .adverts:
            return skills[indexPath.row].title.width(for: type.cellHeight) + type.spacing + 24
        }
    }

    func collectionViewHeight(for contentSize: CGSize) -> CGFloat {
        if type.scrollDirection == .horizontal {
            return type.cellHeight
        }
        return contentSize.height
    }

    // MARK: - EMPTY
    static let empty = SkillsPresentation()
}


// MARK: - Type
extension SkillsPresentation {
    enum `Type` {
        case advert(imageViewContainerViewBorderColor: UIColor)
        case adverts(imageViewContainerBackgroundColor: UIColor)
        case profile(imageViewContainerBackgroundColor: UIColor)

        var axis: NSLayoutConstraint.Axis {
            switch self {
            case .advert, .profile:
                return .vertical

            case .adverts:
                return .horizontal
            }
        }

        var scrollDirection: UICollectionView.ScrollDirection {
            switch self {
            case .advert, .profile:
                return .vertical

            case .adverts:
                return .horizontal
            }
        }

        var spacing: CGFloat {
            return 4.0
        }

        var cellHeight: CGFloat {
            switch self {
            case .advert, .profile:
                return 74

            case .adverts:
                return 24.0
            }
        }

        var imageViewContainerViewWidth: CGFloat {
            switch self {
            case .advert, .profile:
                return 56.0

            case .adverts:
                return 24.0

            }
        }

        var imageViewContainerViewInset: CGFloat {
            switch self {
            case .advert, .profile:
                return 10.0

            case .adverts:
                return 5.0

            }
        }

        var imageViewContainerViewBorderWidth: CGFloat {
            switch self {
            case .advert, .profile:
                return 1.0

            case .adverts:
                return .zero
            }
        }

        var imageViewContainerViewBorderColor: UIColor? {
            switch self {
            case .advert(let color), .profile(let color):
                return color


            case .adverts:
                return nil
            }
        }

        var imageViewContainerViewBackgroundColor: UIColor {
            switch self {
            case .advert, .profile:
                return .clear

            case .adverts(let color):
                return color
            }
        }

        var minimumLineSpacing: CGFloat {
            return 10.0
        }

        var minimumInteritemSpacing: CGFloat {
            switch self.scrollDirection {
            case .horizontal:
                return 10.0

            case .vertical:
                return 24.0

            @unknown default:
                return 10.0
            }
        }
    }
}
