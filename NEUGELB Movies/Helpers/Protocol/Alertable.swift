//
//  Alertable.swift
//  NEUGELB Movies
//
//  Created by Raj S on 08/04/23.
//

import UIKit

// MARK: - Alertable
protocol Alertable {
    func show(alert: AlertData)
}

// MARK: - Alertable + UIViewController
extension Alertable where Self: UIViewController {
    
    func show(alert: AlertData) {
        let controller = UIAlertController(title: alert.title,
                                           message: alert.message,
                                           preferredStyle: .alert)
        alert.actions.forEach { action in
            controller.addAction(.init(title: action.title,
                                       style: .default,
                                       handler: { _ in action.action() }))
        }
        
        self.present(controller, animated: true)
    }
}
