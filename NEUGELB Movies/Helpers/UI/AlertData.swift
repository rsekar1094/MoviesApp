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
        let title: String
        let action: ()->Void
    }
}
