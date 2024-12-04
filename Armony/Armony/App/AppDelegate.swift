//
//  AppDelegate.swift
//  Armony
//
//  Created by Koray Yıldız on 19.08.2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import netfox
import AppTrackingTransparency
import AdSupport

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Variables
    private let navigation: URLNavigation = URLNavigator.shared
    private let authenticator = AuthenticationService.shared
    private let userDefaults = Defaults.shared

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    // MARK: - AppDelegate

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        clearKeychainIfneeded()

        // Configuration
        configureAppAppearance()
        configureNetfox()
        configureNetworkActivityLogger()

        // Firebase
        FirebaseService.shared.start()
        RemoteNotificationService.shared.start()

        // Internet Connection
        InternetConnectionAlertService.shared.start()
        InternetConnectionService.shared.start()

        // Keyboard Manager
        IQKeyboardManager.shared.enable = true

        // Analytic
        MixPanelAnalytic.shared.start(options: launchOptions)
        FirebaseAnalytic.shared.start()
        AdjustAnaltic().start()

        // App start
        AppCoordinator(window: window!).start()

        return true
    }

    func requestATTPermission() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                break
            case .denied:
                break
            case .notDetermined:
                break
            case .restricted:
                break
            default:
                break
            }
        }
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotificationCenter.default.post(
            notification: .deviceTokenDidReceive,
            object: application,
            userInfo: [.deviceToken: deviceToken]
        )
    }


    public func application(_ app: UIApplication,
                            open url: URL,
                            options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        //        DeeplinkService().navigate(url.absoluteString)
        return !navigation.open(url.deeplink, dismissToRoot: true)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        updateAppIconBadgeNumber(application)
        requestATTPermission()
    }
}

// MARK: - Private Methods
private extension AppDelegate {
    func configureNetworkActivityLogger(logger: NetworkActivityLogger = .shared, config: ConfigReader = .shared) {
        logger.startLogging(config: config)
    }

    private func updateAppIconBadgeNumber(_ application: UIApplication) {
        Task {
            let notifications = await UNUserNotificationCenter.current().deliveredNotifications()
            let groupedNotifications = Array(Set(notifications.map { $0.request.identifier }))
            DispatchQueue.main.async {
                application.applicationIconBadgeNumber = groupedNotifications.count
            }
        }
    }

    func configureAppAppearance() {
        UITextView.appearance().tintColor = .armonyWhiteMedium
        UITextField.appearance().tintColor = .armonyWhiteMedium
        configureNavigationBarAppearance()
        configureTabBarAppearance()
    }

    func configureTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .armonyBlack

        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: UIFont.regularBody,
            .foregroundColor: UIColor.armonyWhite
        ]

        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: UIFont.regularBody
        ]

        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
        }
    }

    func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()

        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .armonyBlack
        appearance.setBackIndicatorImage(.navigatorBack, transitionMaskImage: .navigatorBack)
        appearance.titleTextAttributes = [
            .font: UIFont.semiboldHeading,
            .foregroundColor: AppTheme.Color.white.uiColor
        ]

        let barButtonItemAppearance = UIBarButtonItemAppearance()
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]

        appearance.backButtonAppearance = barButtonItemAppearance

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        if #available(iOS 15, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }
    }

    func clearKeychainIfneeded() {
        if !userDefaults[.isFirtRun] {
            userDefaults[.isFirtRun] = true
            authenticator.unauthenticate()
        }
    }

    func configureNetfox() {
        if ConfigReader.shared.environment == .debug {
            NFX.sharedInstance().start()
            NFX.sharedInstance().ignoreURLsWithRegex("^((?!forte-stg).)*$")
        }
    }
}
