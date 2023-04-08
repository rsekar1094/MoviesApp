//
//  CellViewModel.swift
//  NEUGELB Movies
//
//  Created by Raj S on 06/04/23.
//

import Foundation

enum CellViewModel<T : Identifiable>: Hashable,
                                      Equatable,
                                      Identifiable {
    case loading(id: String)
    case data(value: T)
    
    var id: String {
        switch self {
        case .loading(let id):
            return id
        case .data(let value):
            return String(describing: value.id)
        }
    }
    
    static func == (lhs: CellViewModel<T>, rhs: CellViewModel<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading(let lId),.loading(let rId)):
            return lId == rId
        case (.data(let lValue),.data(let rValue)):
            return lValue.id == rValue.id
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var isLoader: Bool {
        switch self {
        case .loading:
            return true
        case .data:
            return false
        }
    }
}
