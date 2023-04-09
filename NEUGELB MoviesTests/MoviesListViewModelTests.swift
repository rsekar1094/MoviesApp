//
//  MoviesListViewModelTests.swift
//  NEUGELB MoviesTests
//
//  Created by Raj S on 09/04/23.
//

import Foundation
import XCTest
import Combine
@testable import NEUGELB_Movies

class MoviesListViewModelTests: XCTestCase {
    var viewModel: MoviesListViewModel!
    let movieRepository = MockMovieRepository()
    let config = ConfigImpl()
    var subscribers: [AnyCancellable] = []
    var mockActionHandler: MoviesListActionHandler!
    var openedAction: MoviesListViewModel.Action?

    override func setUp() {
        super.setUp()
        
        Resolver.shared.add(config,key: String(reflecting: Config.self))
        Resolver.shared.add(movieRepository,key: String(reflecting: MoviesRepository.self))
        
        mockActionHandler = { [weak self] action in
            guard let self else { return }
            self.openedAction = action
        }
        viewModel = MoviesListViewModel(actionHandler: mockActionHandler)
    }

    override func tearDown() {
        mockActionHandler = nil
        viewModel = nil
        openedAction = nil
        
        super.tearDown()
    }
    
    func testFetchAllMovieDataSuccess() async throws {
        // Given
        movieRepository.responseType = .success1

        // When
        await viewModel.refreshData()

        // Then
        XCTAssertEqual(viewModel.datasource.count, 3)
        XCTAssertEqual(viewModel.datasource[0].items.count, 6)
        XCTAssertEqual(viewModel.datasource[1].items.count, 10)
        XCTAssertEqual(viewModel.datasource[2].items.count, 10)
    }
    
    func testFetchPartialMovieDataSuccess() async throws {
        // Given
        movieRepository.responseType = .success2
        
        //  When
        await viewModel.refreshData()

        // Then
        XCTAssertEqual(viewModel.datasource.count, 2)
        XCTAssertEqual(viewModel.datasource[0].items.count, 1)
        XCTAssertEqual(viewModel.datasource[1].items.count, 9)
    }
    
    func testFetchMovieDataFailure() async throws {
        // Given
        movieRepository.responseType = .error

        var isAlertToShowPassed: Bool = false
        viewModel.alertToShow
            .sink { _ in
                isAlertToShowPassed = true
            }
            .store(in: &subscribers)


        // When
        await viewModel.refreshData()

        // Then
        XCTAssertEqual(viewModel.datasource.count, 0)
        XCTAssert(isAlertToShowPassed)
    }

    func testOpenMovieDetail() async throws {
        // Given
        let movie = Movie.getDummy()
        let selectedMovie = MovieCellViewModel(movie: movie,
                                               imagePathResolver: { _ in return "" })
        viewModel.didSelected(item: .movie(.data(value: selectedMovie)))

        // When
        viewModel.requestToOpenDetail()

        // Then
        XCTAssertEqual(openedAction!, .openDetail(movie))
    }


    func testOpenMovieDetailOnLoadingCell() async throws {
        // Given
        viewModel.didSelected(item: .movie(.loading(id: "3")))

        // When
        viewModel.requestToOpenDetail()

        // Then
        XCTAssertEqual(openedAction, nil)
    }

}

extension MoviesListViewModel.Action: Equatable {
    public static func == (_ lhs: MoviesListViewModel.Action,
                           _ rhs: MoviesListViewModel.Action) -> Bool {
        switch (lhs, rhs) {
        case (.openDetail(let left),.openDetail(let right)):
            return left == right
        }
    }
}
