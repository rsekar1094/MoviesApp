//
//  MoviesUsecase.swift
//  NEUGELB Movies
//
//  Created by Raj S on 06/04/23.
//

import Foundation

// MARK: - MoviesUsecase
protocol MoviesUsecase {
    func getAllMoviesData() async throws -> MoviesData
    func getImageFullPath(for id: String) -> String
}

// MARK: - MoviesUsecaseImpl
class MoviesUsecaseImpl: MoviesUsecase {
    
    // MARK: - Properties
    @Inject
    private var moviesRepository: MoviesRepository
    
    @Inject
    private var config: Config
    
    // MARK: - Methods
    func getAllMoviesData() async throws -> MoviesData {
        let allMoviesTask = Task { try await moviesRepository.getAllMovies() }
        let favoriteMoviesTask = Task { try await moviesRepository.getFavoriteMovies() }
        
        // await for both all movies and favorites api to complete
        let (allMovies, favoriteMovieIds) = try await (allMoviesTask.value, favoriteMoviesTask.value)
        
        let movieDict = allMovies.reduce(into: [:]) { dict, movie in dict[movie.id] = movie }
        let favoriteMovies = favoriteMovieIds.compactMap { movieDict[$0.id] }.sorted()
        
        let sortedMovies = allMovies.sorted()
        var watchedMovies: [Movie] = []
        var toWatchMovies: [Movie] = []
        
        sortedMovies.forEach {
            $0.isWatched ? watchedMovies.append($0) : toWatchMovies.append($0)
        }
        
        return MoviesData(watchedMovies: watchedMovies,
                          toWatchMovies: toWatchMovies,
                          favoriteMovies: favoriteMovies)
    }
    
    func getImageFullPath(for path: String) -> String {
        return config.imageBasePath + "/w500" + path
    }
}

// MARK: - MoviesData
struct MoviesData {
    let watchedMovies: [Movie]
    let toWatchMovies: [Movie]
    let favoriteMovies: [Movie]
}
