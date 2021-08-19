//
//  ViewManager.swift
//  CypressApp
//
//  Created by Connor Tam on 7/3/21.
//

import Foundation
import UIKit

/// Searches recursively through the current view and its subviews in a UIViewController for a UIScrollView
private func findScrollView(_ controller: UINavigationController?) -> UIScrollView? {
    return findScrollView(controller?.viewControllers.last?.view)
}

/// Searches recursively through the subviews of the view for a UIScrollView
private func findScrollView(_ view: UIView?) -> UIScrollView? {
    guard let view = view else { return nil }

    var scrollView = view.subviews.first(where: { ($0 as? UIScrollView) != nil }) as? UIScrollView

    guard scrollView == nil else { return scrollView }

    for view in view.subviews {
        scrollView = findScrollView(view)
        guard scrollView == nil else { return scrollView }
    }

    return nil
}

class ViewManager: ObservableObject {
    static var shared = ViewManager()

    var navControllers: [String: UINavigationController] = [:]
    var focusedController: String = ""

    func addNav(name: String, navController: UINavigationController) {
        navControllers[name] = navController
    }

    func popNav(name: String) {
        navControllers[name]?.popViewController(animated: true)
    }

    /// Scrolls to the top of a UIScrollView with respect to its insets
    /// The ContentOffset's y when at the top of a UIScrollView is actually not 0, so we have to respect its insets
    func scrollToTop(controller: UIScrollView) {
        controller.setContentOffset(CGPoint(x: controller.contentOffset.x, y: -controller.contentInset.top), animated: true)
    }

    /// Scrolls view to the top. If the view is already at the top, pop the navigation view. If there is nothing to scroll, pop the navigation view.
    private func onDoubleFocus(name: String) {
        if let scroll = findScrollView(navControllers[name]) {
            if scroll.contentInset.top == -scroll.contentOffset.y {
                popNav(name: name)
            } else {
                scrollToTop(controller: scroll)
            }
        } else {
            popNav(name: name)
        }
    }

    /// Track the focused tab
    func focus(name: String) {
        if focusedController == name {
            onDoubleFocus(name: name)
        }
        focusedController = name
    }
}
