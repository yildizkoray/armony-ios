//
//  GradientPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 21.11.2021.
//

import UIKit

public final class GradientPresentation {

    // MARK: - Color
    public enum Color {
        case advert
        case empty
        case login
        case profile
        case separator

        var colors: [UIColor] {
            switch self {
            case .advert:
                return [
                    UIColor(r: 94, g: 11, b: 167, a: 0.4),
                    UIColor(r: 94, g: 11, b: 167, a: 0.12),
                    UIColor(r: 94, g: 11, b: 167, a: 0.0)
                ]

            case .empty:
                return .empty

            case .login:
                return [
                    UIColor(r: 84, g: 9, b: 155, a: 0.0),
                    UIColor(r: 94, g: 11, b: 167, a: 0.4),
                    UIColor(r: 103, g: 12, b: 179, a: 0.01)
                ]

            case .profile:
                return Color.login.colors

            case .separator:
                return [
                    UIColor(r: 158, g: 243, b: 255, a: 0.8),
                    UIColor(r: 49, g: 64, b: 101, a: 1.0)
                ]
            }
        }

    }

    // MARK: - Orientation
    public enum Orientation {
        case horizontal
        case leftAcross
        case rightAcross
        case vertical

        var endPoint: CGPoint {
            switch self {
            case .horizontal:
                return CGPoint(x: 1.0, y: 0.5)

            case .leftAcross:
                return CGPoint(x: 1.0, y: 0.0)

            case .rightAcross:
                return CGPoint(x: 0.0, y: 0.0)

            case .vertical:
                return CGPoint(x: 0.5, y: 1.0)
            }
        }

        var startPoint: CGPoint {
            switch self {
            case .horizontal:
                return CGPoint(x: 0.0, y: 0.5)

            case .leftAcross:
                return CGPoint(x: 0.0, y: 1.0)

            case .rightAcross:
                return CGPoint(x: 1.0, y: 1.0)

            case .vertical:
                return CGPoint(x: 0.5, y: 0.0)
            }
        }
    }

    let orientation: Orientation
    let color: Color

    // MARK: - Init
    public init(orientation: Orientation, color: Color) {
        self.orientation = orientation
        self.color = color
    }

    private init() {
        orientation = .horizontal
        color = .empty
    }

    // MARK: - EMPTY
    public static let empty = GradientPresentation()
}

public extension GradientPresentation {

    static let separator = GradientPresentation(orientation: .horizontal, color: .separator)
}


