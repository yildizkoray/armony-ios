//
//  PageViewController.swift
//  Armony
//
//  Created by Koray Yildiz on 19.04.22.
//

import UIKit

protocol PageViewControllerDelegate: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: PageViewController, didShowNext nextController: UIViewController, didMoveIndex index: Int)
    func pageViewController(_ pageViewController: PageViewController, didShowPrevious previousController: UIViewController, didMoveIndex index: Int)
}

final class PageViewController: UIPageViewController {

    private(set) var currentIndex: Int = NSNotFound
    private var initialIndex: Int? = nil
    private var controllers: [UIViewController] = []

    override var dataSource: UIPageViewControllerDataSource? {
        willSet {
            if newValue != nil {
                assertionFailure("DataSource can not be nil")
            }
        }
    }

    weak var additionalDelegate: PageViewControllerDelegate?

    func setViewControllers(_ viewControllers: [UIViewController]?, initialIndex: Int? = nil) {
        self.initialIndex = initialIndex
        setViewControllers(viewControllers, direction: .forward, animated: false)
    }

    override func setViewControllers(
        _ viewControllers: [UIViewController]?,
        direction: UIPageViewController.NavigationDirection,
        animated: Bool, completion: ((Bool) -> Void)? = nil
    ) {
        defer {
            controllers.removeAll()
            controllers.append(contentsOf: viewControllers!)
        }
        if let initialIndex = initialIndex {
            if let view = viewControllers?.element(at: initialIndex) {
                currentIndex = initialIndex
                super.setViewControllers([view], direction: .forward, animated: animated, completion: completion)
            }
        }
        else {
            if let viewControllers = viewControllers, let firstViewController = viewControllers.first {
                currentIndex = .zero
                super.setViewControllers([firstViewController], direction: direction, animated: animated, completion: completion)
            }
            else {
                currentIndex = NSNotFound
                super.setViewControllers(viewControllers, direction: direction, animated: animated, completion: completion)
            }
        }
    }

    private func backward(to index: Int, completion: Callback<Bool>? = nil) {
        if let previousView = controllers.element(at: index) {
            currentIndex = index
            super.setViewControllers([previousView], direction: .reverse, animated: false, completion: completion)
            additionalDelegate?.pageViewController(self, didShowPrevious: previousView, didMoveIndex: currentIndex)
        }
    }

    private func forward(to index: Int, completion: Callback<Bool>? = nil) {
        if let nextView = controllers.element(at: index) {
            currentIndex = index
            super.setViewControllers([nextView], direction: .forward, animated: false, completion: completion)
            additionalDelegate?.pageViewController(self, didShowNext: nextView, didMoveIndex: currentIndex)
        }
    }

    func move(at index: Int, completion: Callback<Bool>? = nil) {
        guard index != currentIndex else { return }
        if index > currentIndex {
            forward(to: index, completion: completion)
        }
        else {
            backward(to: index, completion: completion)
        }
    }
}
