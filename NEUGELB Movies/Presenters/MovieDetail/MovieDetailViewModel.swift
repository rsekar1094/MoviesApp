//
//  MovieDetailViewModel.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import Foundation

// MARK: - MovieDetailViewModel
class MovieDetailViewModel {
    
    // MARK: - Properties
    let items: [MovieDetailItem]
    
    // MARK: - Initializers
    init(movie: Movie,
         moviesUsecase: MoviesUsecase = MoviesUsecaseImpl()) {
        self.items = Self.getItems(for: movie, movieUseCase: moviesUsecase)
    }
}
// MARK: - DataSource
private extension MovieDetailViewModel {
    static func getItems(for movie: Movie,
                         movieUseCase: MoviesUsecase) -> [MovieDetailItem] {
        var items: [MovieDetailItem] = []
        
        items.append(.header(.init(movie: movie,
                                   imagePathResolver: movieUseCase.getImageFullPath(for:))))
        
        /// If description is empty then won't add it in the items
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
