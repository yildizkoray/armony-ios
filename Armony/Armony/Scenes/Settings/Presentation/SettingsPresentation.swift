//
//  SettingsPresentation.swift
//  Armony
//
//  Created by Koray Yildiz on 28.05.22.
//

import Foundation

struct SettingsPresentation {
    let items: [SettingPresentation]

    init(settings: [Setting]) {
        self.items = settings.filter { $0.isVisible }.compactMap(SettingPresentation.init)
    }

    // MARK: - EMPTY
    static let empty = SettingsPresentation(settings: .empty)
}

struct SettingPresentation {
    let id: Int
    let deeplink: Deeplink
    let accessoryImageName: String
    let isVisibile: Bool
    let title: String

    init(setting: Setting) {
        self.id = setting.id
        self.deeplink = setting.deeplink
        self.accessoryImageName = setting.accessoryImageName
        self.isVisibile = setting.isVisible
        let localizedTitle = String("Settings_" + setting.id.string, table: .backendSettings)
        self.title = String(format: localizedTitle, Defaults.shared[.region].emptyIfNil)
    }

    private init() {
        self.id = .zero
        self.deeplink = .empty
        self.accessoryImageName = .empty
        self.isVisibile = false
        self.title = .empty
    }

    // MARK: - EMPTY
    static let empty = SettingPresentation()
}
