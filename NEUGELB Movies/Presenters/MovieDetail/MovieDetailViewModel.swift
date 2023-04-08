//
//  MovieDetailViewModel.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import Foundation
class MovieDetailViewModel {
    
    let items: [MovieDetailItem]
    
    init(movie: Movie,
         moviesUsecase: MoviesUsecase = MoviesUsecaseImpl()) {
        self.items = Self.getItems(for: movie, movieUseCase: moviesUsecase)
    }
    
    private static func getItems(for movie: Movie, movieUseCase: MoviesUsecase) -> [MovieDetailItem] {
        var items: [MovieDetailItem] = []
        
        items.append(.header(.init(movie: movie,
                                   imagePathResolver: movieUseCase.getImageFullPath(for:))))
        
        if !movie.overview.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            items.append(.data(title: NSLocalizedString("Description", comment: ""),
                               value: movie.overview))
        }
        
        items.append(.data(title: NSLocalizedString("Rating", comment: ""),
                           value: String(movie.rating)))
        items.append(.data(title: NSLocalizedString("Date", comment: ""),
                           value: movie.releaseDate))
        items.append(.data(title: NSLocalizedString("Original Language", comment: ""),
                           value: movie.originalLanguage.name))
        return items
    }
}


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