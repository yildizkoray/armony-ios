//
//  AvatarPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 8.09.2021.
//

import UIKit

struct AvatarPresentation {

    enum Kind {
        case circled(AvatarPresentation.Configuration)
        case custom(AvatarPresentation.Configuration)

        var size: CGSize {
            switch self {
            case .circled(let config):
                return config.size.size

            case .custom(let config):
                return config.size.size
            }
        }
    }

    // MARK: - Configuration
    struct Configuration {
        enum Size {
            /// 52.0
            case small

            /// 80.0
            case medium

            /// Custom size
            case custom(CGFloat)

            var size: CGSize {
                switch self {
                case .small:
                    return CGSize(size: 52.0)

                case .medium:
                    return CGSize(size: 80.0)

                case .custom(let width):
                    return CGSize(size: width)
                }
            }
        }
        let size: Size
        let radius: AppTheme.Radius?

        init(size: Size, radius: AppTheme.Radius? = nil) {
            self.size = size
            self.radius = radius
        }
    }

    private(set) var kind: AvatarPresentation.Kind
    private(set) var source: ImageSource

    init(kind: AvatarPresentation.Kind, source: ImageSource) {
        self.kind = kind

        switch source {
        case .static(let image):
            self.source = .static(image)

        case .url(let placeholder, let url):
            self.source = .url(placeholder: placeholder ?? .avatarPlaceholder, url)
        }
    }

    // MARK: - EMPTY
    static let empty = AvatarPresentation(kind: .circled(.init(size: .small)), source: .static(.avatarPlaceholder))
}
