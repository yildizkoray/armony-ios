//
//  AppRatingService.swift
//  Armony
//

import Foundation
import StoreKit

final class AppRatingService {
    static let shared = AppRatingService()
    
    private let minimumDaysBetweenRequests: TimeInterval = 60 * 24 * 60 * 60 // 60 days
    
    private init() { }
    
    func requestReviewIfNeeded() {
        let lastReviewRequest: TimeInterval = Defaults.shared[.lastAppReviewRequestDate].ifNil(.zero)
        let now = Date().timeIntervalSince1970
        
        guard now - lastReviewRequest >= minimumDaysBetweenRequests else { return }
        
        if let scene = UIApplication.topMostScene as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            updateLastReviewDate()
        }
    }
    
    private func updateLastReviewDate() {
        Defaults.shared[.lastAppReviewRequestDate] = Date().timeIntervalSince1970
    }
} 
