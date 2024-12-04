//
//  Colors.swift
//  Armony
//
//  Created by Koray Yıldız on 7.09.2021.
//

import UIKit
import SwiftUI

private struct Constants {
    static let colorDescriptionPrefix = "armony"
}

@objcMembers
public final class AppTheme {

    // MARK: - Color
    public enum Color: String, CustomStringConvertible, Decodable {
        case clear

        case black
        case blue
        case blue20
        case darkBlue
        case darkPurple
        case green
        case pink
        case purple
        case red
        case white
        case white04

        public var description: String {
            return Constants.colorDescriptionPrefix + rawValue.titled
        }

        public var isColorExist: Bool {
            let color = UIColor(named: description)
            return color.isNotNil
        }

        public var uiColor: UIColor {
            return self == .clear ? .clear : UIColor(self)
        }

        public var swiftUIColor: SwiftUI.Color {
            return SwiftUI.Color(uiColor)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)

            switch value {
            case .blackColor:
                self = .black

            case .redColor:
                self = .red

            case .pinkColor:
                self = .pink

            case .whiteColor:
                self = .white

            case .blueColor:
                self = .blue

            case .purpleColor:
                self = .purple

            case .greenColor:
                self = .green

            case .darkBlueColor:
                self = .darkBlue

            case .darkPurpleColor:
                self = .darkPurple

            default:
                self = .clear
            }
        }
    }

    // MARK: - Radius
    public enum Radius: CGFloat {
        /// 4
        case low = 4.0
        /// 8
        case medium = 8.0
        /// 16
        case high = 16.0
    }

    // MARK: - Font
    public enum Font: String, CustomStringConvertible {
        case light = "light"
        case regular = "regular"
        case semiBold = "semiBold"

        public var description: String {
            return "Poppins-\(rawValue.titled)"
        }
    }

    public enum FontSize: CGFloat {
        /// 13
        case body = 13.0
        /// 15
        case subheading = 15.0
        /// 17
        case heading = 17.0
        /// 22
        case title = 22.0
    }

    public enum Border: CGFloat {
        /// 1.0
        case `default` = 1.0
    }

    public enum Alpha: CGFloat {
        /// 0.4
        case low = 0.4
        /// 0.6
        case medium = 0.6
        /// 0.8
        case high = 0.8
        /// 1.0
        case `default` = 1.0
    }

    public enum Spacing: CGFloat {
        case eight = 8.0
        case ten = 10.0
        case twelve = 12.0
        case sixteen = 16.0
    }
}
