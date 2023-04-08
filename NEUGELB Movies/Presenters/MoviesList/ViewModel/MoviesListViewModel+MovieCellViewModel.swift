//
//  MoviesListViewModel+Extraction.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import Foundation

// MARK: - MoviesListViewModel + Detail
extension MoviesListViewModel {
    func requestToOpenDetail() {
        guard let movie = selectedMovie?.movie else { return }
        
        actionHandler(.openDetail(movie))
    }
}

typealias ImagePathResolver = (String) -> String

// MARK: - MovieCellViewModel
struct MovieCellViewModel: Hashable, Identifiable {
    var name: String { movie.originalTitle }
    var id: Int { movie.id }
    var backdropImagePath: String { imagePathResolver(movie.backdropPath) }
    var posterImagePath: String { imagePathResolver(movie.posterPath) }
    
    fileprivate let movie: Movie
    fileprivate let imagePathResolver: ImagePathResolver
    
    init(movie: Movie,
         imagePathResolver: @escaping ImagePathResolver) {
        self.movie = movie
        self.imagePathResolver = imagePathResolver
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(movie)
    }
    
    static func == (lhs: MovieCellViewModel, rhs: MovieCellViewModel) -> Bool {
        lhs.movie == rhs.movie
    }
}
