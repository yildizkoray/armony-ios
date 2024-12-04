//
//  UIStoryboard+Extensions.swift
//  Armony
//
//  Created by Koray Yıldız on 22.08.2021.
//

import UIKit

public extension UIStoryboard {
    
    func allocate<V: UIViewController>(with identifier: String) -> V {
        let view = instantiateViewController(withIdentifier: identifier) as! V
        return view
    }
}

// MARK: - UIStoryboard + Name
public extension UIStoryboard {
    
    enum Name: String, CustomStringConvertible {

        case account
        case chat
        case placeAdvert
        case home
        case login
        case onboarding
        case registration
        case settings
        case visitedAccount
        case splash
        case web
        case hosting

        case none
        
        public var description: String {
            return rawValue.titled
        }
    }
}

// MARK: - StoryboardLoader
public class StoryboardLoader {
    
    static let shared = StoryboardLoader()
    
    private let bundle: Bundle
    private var cache: [String: UIStoryboard]
    private let notifier: NotificationCenter
    private var memoryWarningNotificationToken: NotificationToken? = nil
    
    public init(bundle: Bundle = .main, notifier: NotificationCenter = .default) {
        self.bundle = bundle
        cache = [:]
        self.notifier = notifier
        
        memoryWarningNotificationToken = self.notifier.observe(name: UIApplication.didReceiveMemoryWarningNotification) { [weak self] _ in
            guard let self = self,
                  let memoryWarningNotificationToken = self.memoryWarningNotificationToken else { return }
            self.cache.removeAll(keepingCapacity: false)
            self.notifier.removeObserver(memoryWarningNotificationToken)
        }
    }
    
    func board(with name: UIStoryboard.Name) -> UIStoryboard {
        if let board = cache[name.description] {
            return board
        }
        else {
            let board = UIStoryboard(name: name.description, bundle: bundle)
            cache[name.description] = board
            return board
        }
    }
}
