//
//  MoviesUsecaseImplTests.swift
//  NEUGELB MoviesTests
//
//  Created by Raj S on 08/04/23.
//

import Foundation
import XCTest
@testable import NEUGELB_Movies

class MoviesUsecaseImplTests: XCTestCase {
    
    var usecase: MoviesUsecaseImpl!
    let movieRepository = MockMovieRepository()
    let config = ConfigImpl()
    
    override func setUp() {
        super.setUp()
        Resolver.shared.add(config,key: String(reflecting: Config.self))
        Resolver.shared.add(movieRepository,key: String(reflecting: MoviesRepository.self))
        
        usecase = MoviesUsecaseImpl()
    }
    
    override func tearDown() {
        usecase = nil
        super.tearDown()
    }
    
    func testGetAllMoviesData() async throws {
        // given
        movieRepository.responseType = .success1
        let expectedWatchedMoviesCount = 10
        let expectedToWatchMoviesCount = 10
        let expectedFavoriteMoviesCount = 6
        
        // when
        let moviesData = try await usecase.getAllMoviesData()
        
        // then
        XCTAssertEqual(moviesData.watchedMovies.count, expectedWatchedMoviesCount)
        XCTAssertEqual(moviesData.toWatchMovies.count, expectedToWatchMoviesCount)
        XCTAssertEqual(moviesData.favoriteMovies.count, expectedFavoriteMoviesCount)
    }
    
    func testGetPartialMoviesData() async throws {
        // given
        movieRepository.responseType = .success2
        let expectedWatchedMoviesCount = 9
        let expectedToWatchMoviesCount = 0
        let expectedFavoriteMoviesCount = 1
        
        // when
        let moviesData = try await usecase.getAllMoviesData()
        
        // then
        XCTAssertEqual(moviesData.watchedMovies.count, expectedWatchedMoviesCount)
        XCTAssertEqual(moviesData.toWatchMovies.count, expectedToWatchMoviesCount)
        XCTAssertEqual(moviesData.favoriteMovies.count, expectedFavoriteMoviesCount)
    }
    
    func testErrorMoviesData() async throws {
        // given
        movieRepository.responseType = .error
        
        // when
        let moviesData = try? await usecase.getAllMoviesData()
        
        // then
        XCTAssert(moviesData == nil)
    }
    
    func testMovieSorting() async throws {
        // given
        movieRepository.responseType = .success1
        
        // when
        let moviesData = try await usecase.getAllMoviesData()
        
        // then
        XCTAssertEqual(moviesData.watchedMovies[0].originalTitle,"BAC Nord")
        XCTAssertEqual(moviesData.watchedMovies[1].originalTitle,"Free Guy")
    }
    
    func testGetImageFullPath() {
        // given
        let expectedPath = "https://image.tmdb.org/t/p/w500/test.jpg"
        
        // when
        let fullPath = usecase.getImageFullPath(for: "/test.jpg")
        
        // then
        XCTAssertEqual(fullPath, expectedPath)
    }
}
