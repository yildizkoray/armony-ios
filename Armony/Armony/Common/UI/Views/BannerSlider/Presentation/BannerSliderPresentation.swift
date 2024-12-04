//
//  BannerSliderPresentation.swift
//  Armony
//
//  Created by Koray Yıldız on 1.02.2024.
//

import Foundation

struct BannerSliderPresentation {
    let isActive: Bool
    let banners: [BannerSliderItemPresentation]

    let adjustEvents = [
        "iy2amx",
        "scd9hx",
        "xy012u"
    ]

    let firebaseEvents = [
        BannerSliderFirebaseEvent(category: "Zuhal Akademi"),
        BannerSliderFirebaseEvent(category: "Survey"),
        BannerSliderFirebaseEvent(category: "Youtube")
    ]

    init(isActive: Bool, banners: [BannerSlider]) {
        self.isActive = isActive
        self.banners = banners.compactMap {
            return BannerSliderItemPresentation(title: $0.title,
                                                imageURL: $0.image,
                                                deeplink: $0.deeplink,
                                                backgroundColor: $0.backgroundColor)
        }
    }

    static let empty = BannerSliderPresentation(isActive: false, banners: .empty)
}

struct BannerSliderItemPresentation {
    let title: String
    let imageURL: URL
    let deeplink: Deeplink
    let backgroundColor: AppTheme.Color
}

struct BannerSliderAdjustEvent: AdjustEvent {
    var token: String
}

struct BannerSliderFirebaseEvent: FirebaseEvent {
    var name: String = "click_banner_slider"
    var category: String
    var action: String = "Click Banner"
}
