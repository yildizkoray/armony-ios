//
//  EmptyStatePresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 17.05.22.
//

import Foundation
import UIKit

struct EmptyStatePresentation {
    let image: UIImage?
    let title: NSAttributedString
    let subtitle: NSAttributedString?
    let buttonTitle: NSAttributedString?

    init(image: UIImage? = nil,
         title: NSAttributedString,
         subtitle: NSAttributedString? = nil,
         buttonTitle: NSAttributedString? = nil) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
    }

    init(image: UIImage? = nil,
         title: String,
         subtitle: String? = nil,
         buttonTitle: String? = nil) {
        self.init(
            image: image,
            title: title.emptyStateTitleAttributed,
            subtitle: subtitle?.emptyStateSubtitleAttributed,
            buttonTitle: buttonTitle?.emptyStateButtonAttributed
        )
    }
}
