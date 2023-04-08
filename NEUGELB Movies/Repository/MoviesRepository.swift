//
//  MoviesRepository.swift
//  NEUGELB Movies
//
//  Created by Raj S on 06/04/23.
//

import Foundation

// MARK: - MoviesRepository
protocol MoviesRepository {
    func getAllMovies() async throws -> [Movie]
    func getFavoriteMovies() async throws -> [FavoriteMovie]
}

// MARK: - MoviesRepositoryImpl
final class MoviesRepositoryImpl: MoviesRepository {
    
    @Inject
    private var networkManager: NetworkManaging
    
    func getAllMovies() async throws -> [Movie] {
        let data: NetworkResponse<[Movie]> = try await networkManager.fetch(path: ApiPath.movies)
        return data.results
    }
    
    func getFavoriteMovies() async throws -> [FavoriteMovie] {
        let data: NetworkResponse<[FavoriteMovie]> = try await networkManager.fetch(path: ApiPath.favorites)
        return data.results
    }
    
    // MARK: - ApiPath
    private struct ApiPath {
        static let movies = "movies/list"
        static let favorites = "movies/favorites"
    }
}
