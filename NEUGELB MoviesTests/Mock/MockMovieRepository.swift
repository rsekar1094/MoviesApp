//
//  MockMovieRepository.swift
//  NEUGELB MoviesTests
//
//  Created by Raj S on 08/04/23.
//

import Foundation
@testable import NEUGELB_Movies

class MockMovieRepository: MoviesRepository {
    var responseType: ResponseType = .error
    
    func getAllMovies() async throws -> [NEUGELB_Movies.Movie] {
        switch responseType {
        case .error:
            throw NSError(domain: "test", code: 304)
        case .success1:
            let response: NetworkResponse<[Movie]> = try JsonDecoder().decode(for: "movieListJson1")
            return response.results
        case .success2:
            let response: NetworkResponse<[Movie]> = try JsonDecoder().decode(for: "movieListJson2")
            return response.results
        }
    }
    
    func getFavoriteMovies() async throws -> [NEUGELB_Movies.FavoriteMovie] {
        switch responseType {
        case .error:
            throw NSError(domain: "test", code: 304)
        case .success1:
            let response: NetworkResponse<[FavoriteMovie]> = try JsonDecoder().decode(for: "movieFavoritesJson1")
            return response.results
        case .success2:
            let response: NetworkResponse<[FavoriteMovie]> = try JsonDecoder().decode(for: "movieFavoritesJson2")
            return response.results
        }
    }
    
    enum ResponseType {
        case error
        case success1
        case success2
    }
}
