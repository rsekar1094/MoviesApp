//
//  MoviesListViewModelTests.swift
//  NEUGELB MoviesTests
//
//  Created by Raj S on 09/04/23.
//

import Foundation
import XCTest
@testable import NEUGELB_Movies

class MoviesListViewModelTests: XCTestCase {
    
    var viewModel: MoviesListViewModel!
    let movieRepository = MockMovieRepository()
    let config = ConfigImpl()
    var mockActionHandler: MoviesListActionHandler!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        Resolver.shared.add(config,key: String(reflecting: Config.self))
        Resolver.shared.add(movieRepository,key: String(reflecting: MoviesRepository.self))
        
        mockActionHandler = { _ in }
        viewModel = MoviesListViewModel(actionHandler: mockActionHandler)
    }

    override func tearDownWithError() throws {
        mockActionHandler = nil
        viewModel = nil
        
        try super.tearDownWithError()
    }
    
    func testFetchAllMovieDataSuccess() async throws {
        // Given
        movieRepository.responseType = .success1
        
        // When
        viewModel.requestToRefresh()
        
        let expectation = XCTestExpectation(description: "test")
        wait(for: [expectation], timeout: 4.0)
        
        // Then
        XCTAssertEqual(viewModel.datasource.count, 3)
        XCTAssertEqual(viewModel.datasource[0].items.count, 6)
        XCTAssertEqual(viewModel.datasource[1].items.count, 10)
        XCTAssertEqual(viewModel.datasource[2].items.count, 10)
    }
    
    func testFetchPartialMovieDataSuccess() async throws {
        // Given
        movieRepository.responseType = .success2
        
        // When
        viewModel.requestToRefresh()
        
        let expectation = XCTestExpectation(description: "test")
        wait(for: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertEqual(viewModel.datasource.count, 2)
        XCTAssertEqual(viewModel.datasource[0].items.count, 1)
        XCTAssertEqual(viewModel.datasource[1].items.count, 9)
    }
    
    func testFetchMovieDataFailure() async throws {
        // Given
        movieRepository.responseType = .error
        
        // When
        viewModel.requestToRefresh()
        
        // Then
        XCTAssertEqual(viewModel.datasource.count, 0)
    }

}
