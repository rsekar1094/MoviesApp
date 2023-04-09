//
//  AlertData.swift
//  NEUGELB Movies
//
//  Created by Raj S on 08/04/23.
//

import Foundation

// MARK: - AlertData
struct AlertData {
    let title: String
    let message: String
    let actions: [Action]
    
    // MARK: - Action
    struct Action {
        internal init(title: String,
                      action: @escaping () -> Void = { }) {
            self.title = title
            self.action = action
        }

        let title: String
        let action: ()->Void
    }
}
