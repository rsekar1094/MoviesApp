//
//  MovieDetailItem.swift
//  NEUGELB Movies
//
//  Created by Rajasekhar Rajendran on 09.04.23.
//

import Foundation

// MARK: - MovieDetailItem
enum MovieDetailItem: Hashable {
    case header(MovieCellViewModel)
    case data(title: String, value: String)

    func hash(into hasher: inout Hasher) {
        switch self {
        case .header(let movieCellViewModel):
            hasher.combine(movieCellViewModel)
        case .data(let title, _):
            hasher.combine(title)
        }
    }
}
