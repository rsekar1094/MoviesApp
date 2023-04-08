//
//  MovieListSection.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import Foundation

enum MovieListSection: Hashable {
    case favorites([MovieListItem])
    case watched([MovieListItem])
    case toWatch([MovieListItem])
    
    var canScrollHorizontally: Bool {
        switch self {
        case .favorites:
            return true
        case .watched,.toWatch:
            return false
        }
    }
    
    var items: [MovieListItem] {
        switch self {
        case .favorites(let items):
            return items
        case .watched(let items):
            return items
        case .toWatch(let items):
            return items
        }
    }
    
    var title: String {
        switch self {
        case .favorites:
            return NSLocalizedString("Favorites", comment: "")
        case .watched:
            return NSLocalizedString("Watched", comment: "")
        case .toWatch:
            return NSLocalizedString("To watch", comment: "")
        }
    }
}

enum MovieListItem: Hashable {
    case favotieMovie(CellViewModel<MovieCellViewModel>)
    case movie(CellViewModel<MovieCellViewModel>)
    
    var data: CellViewModel<MovieCellViewModel> {
        switch self {
        case .favotieMovie(let item):
            return item
        case .movie(let item):
            return item
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .favotieMovie(let cellViewModel):
            hasher.combine(cellViewModel)
            hasher.combine("favotieMovie")
        case .movie(let cellViewModel):
            hasher.combine(cellViewModel)
        }
    }
}
