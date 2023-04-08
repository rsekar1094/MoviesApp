//
//  UIScrollView+Refresh.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import UIKit
extension UIScrollView {
    func addRefreshControl(target: Any?, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
    }
    
    func endRefreshing() {
        refreshControl?.endRefreshing()
    }
}
