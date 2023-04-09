//
//  MovieDetailViewModelTests.swift
//  NEUGELB MoviesTests
//
//  Created by Rajasekhar Rajendran on 09.04.23.
//

import Foundation
import XCTest
@testable import NEUGELB_Movies

class MovieDetailViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()

        Resolver.shared.add(ConfigImpl(),
                            key: String(reflecting: Config.self))
        Resolver.shared.add(MockMovieRepository(),
                            key: String(reflecting: MoviesRepository.self))
    }

    func testMovieDetailItemsWithOverview() async throws {
        // Given
        let movie = Movie.getDummy(overview: "overview")
        let viewModel = MovieDetailViewModel(movie: movie)

        // Then
        XCTAssertEqual(viewModel.items.count, 5)
    }

    func testMovieDetailItemsWithOutOverview() async throws {
        // Given
        let movie = Movie.getDummy()
        let viewModel = MovieDetailViewModel(movie: movie)

        // Then
        XCTAssertEqual(viewModel.items.count, 4)
    }
    
}
