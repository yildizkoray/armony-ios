//
//  RefreshControlShowing.swift
//  Armony
//
//  Created by Koray Yıldız on 10.10.22.
//

import Foundation
import UIKit

protocol RefreshControlShowing {
    var containerScrollView: UIScrollView { get }

    func addRefresher(_ target: Any, color: UIColor, selector: Selector)
    func addRefresher(_ target: Any, color: AppTheme.Color, selector: Selector)
    func endRefreshing()
}

extension RefreshControlShowing {

    func addRefresher(_ target: Any, color: AppTheme.Color, selector: Selector) {
        addRefresher(target, color: color.uiColor, selector: selector)
    }

    func addRefresher(_ target: Any, color: UIColor, selector: Selector) {
        let refresher = UIRefreshControl()
        refresher.tintColor = color
        refresher.addTarget(target, action: selector, for: .valueChanged)
        containerScrollView.refreshControl = refresher
    }

    func endRefreshing() {
        containerScrollView.refreshControl?.endRefreshing()
    }
}
