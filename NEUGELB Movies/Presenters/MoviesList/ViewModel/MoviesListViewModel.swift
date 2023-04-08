//
//  MoviesListViewModel.swift
//  NEUGELB Movies
//
//  Created by Raj S on 06/04/23.
//

import Foundation
import Combine

typealias MoviesListActionHandler = (MoviesListViewModel.Action) -> Void

class MoviesListViewModel {
    enum Action {
        case openDetail(Movie)
    }
    
    let actionHandler: MoviesListActionHandler
    let moviesUsecase: MoviesUsecase
    
    @Published
    var selectedMovie: MovieCellViewModel?
    
    @Published
    var datasource: [MovieListSection] = []
    
    
    init(moviesUsecase: MoviesUsecase = MoviesUsecaseImpl(),
         actionHandler: @escaping MoviesListActionHandler) {
        self.moviesUsecase = moviesUsecase
        self.actionHandler = actionHandler
    }
    
    func didViewLoaded() {
        fetchMovieData()
    }
    
    func requestToRefresh() {
        fetchMovieData()
    }
    
    func requestToOpenDetail() {
        guard let movie = selectedMovie?.movie else { return }
        actionHandler(.openDetail(movie))
    }
    
    func didSelected(item: MovieListItem) {
        switch item.data {
        case .data(value: let movieViewModel):
            self.selectedMovie = movieViewModel
        case .loading:
            break
        }
    }
    
    private func fetchMovieData() {
        self.datasource = [
            .favorites( (0...4).map { _ in .favotieMovie(.loading(id: UUID().uuidString)) } ),
            .toWatch( (0...4).map { _ in .movie(.loading(id: UUID().uuidString)) } ),
            .watched( (0...4).map { _ in .movie(.loading(id: UUID().uuidString)) } )
        ]
        
        Task {
            do {
                let movieData = try await moviesUsecase.getAllMoviesData()
                
                var dataSource: [MovieListSection] = []
                
                if !movieData.favoriteMovies.isEmpty {
                    dataSource.append(.favorites(movieData.favoriteMovies.map {
                        .favotieMovie(.data(value: .init(movie: $0,
                                                         imagePathResolver: moviesUsecase.getImageFullPath(for:))))
                    }))
                }
                
                
                if !movieData.toWatchMovies.isEmpty {
                    dataSource.append(.toWatch(movieData.toWatchMovies.map {
                        .movie(.data(value: .init(movie: $0,
                                                         imagePathResolver: moviesUsecase.getImageFullPath(for:))))
                    }))
                }
                
                if !movieData.watchedMovies.isEmpty {
                    dataSource.append(.watched(movieData.watchedMovies.map {
                        .movie(.data(value: .init(movie: $0,
                                                         imagePathResolver: moviesUsecase.getImageFullPath(for:))))
                    }))
                }
                
                self.datasource = dataSource
            } catch let error {
                
            }
        }
        
    }
}


typealias ImagePathResolver = (String) -> String

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
