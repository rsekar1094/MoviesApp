//
//  MoviesListViewModel.swift
//  NEUGELB Movies
//
//  Created by Raj S on 06/04/23.
//

import Foundation
import Combine

typealias MoviesListActionHandler = (MoviesListViewModel.Action) -> Void

// MARK: - MoviesListViewModel
class MoviesListViewModel {
    enum Action {
        case openDetail(Movie)
    }
    
    // MARK: - Properties
    let actionHandler: MoviesListActionHandler
    let moviesUsecase: MoviesUsecase
    let alertToShow: PassthroughSubject<AlertData,Never> = .init()

    @Published
    private(set) var selectedMovie: MovieCellViewModel?
    
    @Published
    private(set) var datasource: [MovieListSection] = []
    
    // MARK: - Initializers
    init(moviesUsecase: MoviesUsecase = MoviesUsecaseImpl(),
         actionHandler: @escaping MoviesListActionHandler) {
        self.moviesUsecase = moviesUsecase
        self.actionHandler = actionHandler
    }
    
    // MARK: - Actions
    func didViewLoaded() {
        requestToRefresh()
    }
    
    func requestToRefresh() {
        Task {
            await refreshData()
        }
    }

    func refreshData() async {
        do {
            try await self.fetchMovieData()
        } catch let error {
            self.datasource = []
            alertToShow.send(.init(title: NSLocalizedString("Error", comment: ""),
                                   message: error.localizedDescription,
                                   actions: [.init(title: NSLocalizedString("Ok", comment: ""))]))
        }
    }
    
    func didSelected(item: MovieListItem) {
        switch item.data {
        case .data(value: let movieViewModel):
            self.selectedMovie = movieViewModel
        case .loading:
            break
        }
    }
}
// MARK: - API
private extension MoviesListViewModel {
    func fetchMovieData() async throws {
        updateMovieListAsPlaceholder()
        
        let movieData = try await moviesUsecase.getAllMoviesData()
        
        var dataSource: [MovieListSection] = []
        
        append(movies: movieData.favoriteMovies,for: .favorites, in: &dataSource)
        append(movies: movieData.watchedMovies,for: .watched, in: &dataSource)
        append(movies: movieData.toWatchMovies,for: .toWatch, in: &dataSource)
        
        self.datasource = dataSource
    }
    
    func append(movies: [Movie],
                for type: MovieListSectionType,
                in dataSource: inout [MovieListSection]) {
        guard !movies.isEmpty else { return }
        
        let items: [CellViewModel<MovieCellViewModel>] = movies.map {
            .data(value: .init(movie: $0, imagePathResolver: moviesUsecase.getImageFullPath(for:)))
        }
        
        switch type {
        case .favorites:
            dataSource.append(.favorites(items.map { .favotieMovie($0) }))
        case .watched:
            dataSource.append(.watched(items.map { .movie($0) }))
        case .toWatch:
            dataSource.append(.toWatch(items.map { .movie($0) }))
        }
    }
    
    func updateMovieListAsPlaceholder() {
        self.datasource = [
            .favorites( (0...4).map { _ in .favotieMovie(.loading(id: UUID().uuidString)) } ),
            .toWatch( (0...4).map { _ in .movie(.loading(id: UUID().uuidString)) } ),
            .watched( (0...4).map { _ in .movie(.loading(id: UUID().uuidString)) } )
        ]
    }
}
