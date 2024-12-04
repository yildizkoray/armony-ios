//
//  MockAccountView.swift
//  ArmonyTests
//
//  Created by Koray Yildiz on 16.07.22.
//

import UIKit
@testable import Armony

final class MockAccountView: AccountViewDelegate {

    var invokedConfigurePager = false
    var invokedConfigurePagerCount = 0
    var invokedConfigurePagerParameters: (skills: SkillsPresentation, musicGenres: MusicGenresPresentation)?
    var invokedConfigurePagerParametersList = [(skills: SkillsPresentation, musicGenres: MusicGenresPresentation)]()

    func configurePager(skills: SkillsPresentation, musicGenres: MusicGenresPresentation) {
        invokedConfigurePager = true
        invokedConfigurePagerCount += 1
        invokedConfigurePagerParameters = (skills, musicGenres)
        invokedConfigurePagerParametersList.append((skills, musicGenres))
    }

    var invokedConfigureUserSummaryView = false
    var invokedConfigureUserSummaryViewCount = 0
    var invokedConfigureUserSummaryViewParameters: (presentation: UserSummaryPresentation, Void)?
    var invokedConfigureUserSummaryViewParametersList = [(presentation: UserSummaryPresentation, Void)]()

    func configureUserSummaryView(with presentation: UserSummaryPresentation) {
        invokedConfigureUserSummaryView = true
        invokedConfigureUserSummaryViewCount += 1
        invokedConfigureUserSummaryViewParameters = (presentation, ())
        invokedConfigureUserSummaryViewParametersList.append((presentation, ()))
    }

    var invokedSetBioLabelText = false
    var invokedSetBioLabelTextCount = 0
    var invokedSetBioLabelTextParameters: (bio: String?, Void)?
    var invokedSetBioLabelTextParametersList = [(bio: String?, Void)]()

    func setBioLabelText(_ bio: String?) {
        invokedSetBioLabelText = true
        invokedSetBioLabelTextCount += 1
        invokedSetBioLabelTextParameters = (bio, ())
        invokedSetBioLabelTextParametersList.append((bio, ()))
    }

    var invokedSelectSegment = false
    var invokedSelectSegmentCount = 0
    var invokedSelectSegmentParameters: (index: Int, Void)?
    var invokedSelectSegmentParametersList = [(index: Int, Void)]()

    func selectSegment(at index: Int) {
        invokedSelectSegment = true
        invokedSelectSegmentCount += 1
        invokedSelectSegmentParameters = (index, ())
        invokedSelectSegmentParametersList.append((index, ()))
    }

    var invokedStartEditButtonActivityIndicatorView = false
    var invokedStartEditButtonActivityIndicatorViewCount = 0

    func startEditButtonActivityIndicatorView() {
        invokedStartEditButtonActivityIndicatorView = true
        invokedStartEditButtonActivityIndicatorViewCount += 1
    }

    var invokedStopEditButtonActivityIndicatorView = false
    var invokedStopEditButtonActivityIndicatorViewCount = 0

    func stopEditButtonActivityIndicatorView() {
        invokedStopEditButtonActivityIndicatorView = true
        invokedStopEditButtonActivityIndicatorViewCount += 1
    }

    var invokedStartAccountSubdetailEmptyStateButtonActivityIndicatorView = false
    var invokedStartAccountSubdetailEmptyStateButtonActivityIndicatorViewCount = 0

    func startAccountSubdetailEmptyStateButtonActivityIndicatorView() {
        invokedStartAccountSubdetailEmptyStateButtonActivityIndicatorView = true
        invokedStartAccountSubdetailEmptyStateButtonActivityIndicatorViewCount += 1
    }

    var invokedStopAccountSubdetailEmptyStateButtonActivityIndicatorView = false
    var invokedStopAccountSubdetailEmptyStateButtonActivityIndicatorViewCount = 0

    func stopAccountSubdetailEmptyStateButtonActivityIndicatorView() {
        invokedStopAccountSubdetailEmptyStateButtonActivityIndicatorView = true
        invokedStopAccountSubdetailEmptyStateButtonActivityIndicatorViewCount += 1
    }

    var invokedMakeNavigationBarTransparent = false
    var invokedMakeNavigationBarTransparentCount = 0

    func makeNavigationBarTransparent() {
        invokedMakeNavigationBarTransparent = true
        invokedMakeNavigationBarTransparentCount += 1
    }

    var invokedSetNavigationBarBackgroundColorColorUIColor = false
    var invokedSetNavigationBarBackgroundColorColorUIColorCount = 0
    var invokedSetNavigationBarBackgroundColorColorUIColorParameters: (color: UIColor, Void)?
    var invokedSetNavigationBarBackgroundColorColorUIColorParametersList = [(color: UIColor, Void)]()

    func setNavigationBarBackgroundColor(color: UIColor) {
        invokedSetNavigationBarBackgroundColorColorUIColor = true
        invokedSetNavigationBarBackgroundColorColorUIColorCount += 1
        invokedSetNavigationBarBackgroundColorColorUIColorParameters = (color, ())
        invokedSetNavigationBarBackgroundColorColorUIColorParametersList.append((color, ()))
    }

    var invokedSetNavigationBarBackgroundColorColorAppThemeColor = false
    var invokedSetNavigationBarBackgroundColorColorAppThemeColorCount = 0
    var invokedSetNavigationBarBackgroundColorColorAppThemeColorParameters: (color: AppTheme.Color, Void)?
    var invokedSetNavigationBarBackgroundColorColorAppThemeColorParametersList = [(color: AppTheme.Color, Void)]()

    func setNavigationBarBackgroundColor(color: AppTheme.Color) {
        invokedSetNavigationBarBackgroundColorColorAppThemeColor = true
        invokedSetNavigationBarBackgroundColorColorAppThemeColorCount += 1
        invokedSetNavigationBarBackgroundColorColorAppThemeColorParameters = (color, ())
        invokedSetNavigationBarBackgroundColorColorAppThemeColorParametersList.append((color, ()))
    }

    var invokedSetNavigationBarTitleAttributes = false
    var invokedSetNavigationBarTitleAttributesCount = 0
    var invokedSetNavigationBarTitleAttributesParameters: (attributes: [NSAttributedString.Key: Any], Void)?
    var invokedSetNavigationBarTitleAttributesParametersList = [(attributes: [NSAttributedString.Key: Any], Void)]()

    func setNavigationBarTitleAttributes(_ attributes: [NSAttributedString.Key: Any]) {
        invokedSetNavigationBarTitleAttributes = true
        invokedSetNavigationBarTitleAttributesCount += 1
        invokedSetNavigationBarTitleAttributesParameters = (attributes, ())
        invokedSetNavigationBarTitleAttributesParametersList.append((attributes, ()))
    }

    var invokedSetNavigationItemTitle = false
    var invokedSetNavigationItemTitleCount = 0
    var invokedSetNavigationItemTitleParameters: (title: String, Void)?
    var invokedSetNavigationItemTitleParametersList = [(title: String, Void)]()

    func setNavigationItemTitle(_ title: String) {
        invokedSetNavigationItemTitle = true
        invokedSetNavigationItemTitleCount += 1
        invokedSetNavigationItemTitleParameters = (title, ())
        invokedSetNavigationItemTitleParametersList.append((title, ()))
    }

    var invokedSetTitle = false
    var invokedSetTitleCount = 0
    var invokedSetTitleParameters: (title: String, Void)?
    var invokedSetTitleParametersList = [(title: String, Void)]()

    func setTitle(_ title: String) {
        invokedSetTitle = true
        invokedSetTitleCount += 1
        invokedSetTitleParameters = (title, ())
        invokedSetTitleParametersList.append((title, ()))
    }

    var invokedSetDismissButton = false
    var invokedSetDismissButtonCount = 0
    var invokedSetDismissButtonParameters: (completion: VoidCallback?, Void)?
    var invokedSetDismissButtonParametersList = [(completion: VoidCallback?, Void)]()

    func setDismissButton(completion: VoidCallback?) {
        invokedSetDismissButton = true
        invokedSetDismissButtonCount += 1
        invokedSetDismissButtonParameters = (completion, ())
        invokedSetDismissButtonParametersList.append((completion, ()))
    }

    var invokedStartRightBarButtonItemActivityIndicatorView = false
    var invokedStartRightBarButtonItemActivityIndicatorViewCount = 0

    func startRightBarButtonItemActivityIndicatorView() {
        invokedStartRightBarButtonItemActivityIndicatorView = true
        invokedStartRightBarButtonItemActivityIndicatorViewCount += 1
    }

    var invokedStopRightBarButtonItemActivityIndicatorView = false
    var invokedStopRightBarButtonItemActivityIndicatorViewCount = 0

    func stopRightBarButtonItemActivityIndicatorView() {
        invokedStopRightBarButtonItemActivityIndicatorView = true
        invokedStopRightBarButtonItemActivityIndicatorViewCount += 1
    }

    func addNotch() {
        
    }
}

