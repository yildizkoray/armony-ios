//
//  Deeplink+Register.swift
//  Armony
//
//  Created by Koray Yıldız on 17.10.22.
//

import Foundation

public extension URLNavigation {

    static func initialize(_ navigation: Self) -> Self {
        AdvertsCoordinator.register(navigator: navigation)
        AccountCoordinator.register(navigator: navigation)
        AccountInformationCoordinator.register(navigator: navigation)
        AdvertCoordinator.register(navigator: navigation)
        AdvertListingCoordinator.register(navigator: navigation)
        ChangePasswordCoordinator.register(navigator: navigation)
        ChatsCoordinator.register(navigator: navigation)
        PlaceAdvertCoordinator.register(navigator: navigation)
        LiveChatCoordinator.register(navigator: navigation)
        FeedbackCoordinator.register(navigator: navigation)
        LogOutBottomPopUpCoordinator.register(navigator: navigation)
        RegistrationCoordinator.register(navigator: navigation)
        SettingsCoordinator.register(navigator: navigation)
        VisitedAccountCoordinator.register(navigator: navigation)
        WebCoordinator.register(navigator: navigation)
        if #available(iOS 16, *) {
            RegionsCoordinator.register(navigator: navigation)
        }
        return navigation
    }
}
