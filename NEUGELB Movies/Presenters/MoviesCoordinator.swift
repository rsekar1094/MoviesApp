//
//  MoviesCoordinator.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import UIKit

// MARK: - MoviesCoordinator
class MoviesCoordinator {
    
    // MARK: - Properties
    private weak var navigationController: UINavigationController?

    @Inject
    private var theme: Theme
    
    func start(with window: UIWindow?) {
        let controller = MoviesListController(viewModel: getMovieListViewModel())
        controller.navigationItem.largeTitleDisplayMode = .always
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.prefersLargeTitles = true
        nav.view.backgroundColor = theme.color.background
        window?.rootViewController = nav
        
        self.navigationController = nav
    }
}
// MARK: - MoviesCoordinator + MovieListViewModel
private extension MoviesCoordinator {
    func getMovieListViewModel() -> MoviesListViewModel {
        return MoviesListViewModel { action in
            switch action {
            case .openDetail(let movie):
                self.openMovieDetail(for: movie)
            }
        }
    }
}
// MARK: - MoviesCoordinator + MovieDetail
private extension MoviesCoordinator {
    func openMovieDetail(for movie: Movie) {
        let controller = MovieDetailViewController(viewModel: .init(movie: movie))
        controller.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
