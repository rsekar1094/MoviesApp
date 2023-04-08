//
//  MoviesCoordinator.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import UIKit

class MoviesCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    func start(with window: UIWindow?) {
        let moviesListViewModel = MoviesListViewModel { action in
            switch action {
            case .openDetail(let movie):
                let controller = MovieDetailViewController(viewModel: .init(movie: movie))
                controller.navigationItem.largeTitleDisplayMode = .never
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        let controller = MoviesListController(viewModel: moviesListViewModel)
        controller.navigationItem.largeTitleDisplayMode = .always
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.prefersLargeTitles = true
        nav.view.backgroundColor = .white
        window?.rootViewController = nav
        self.navigationController = nav
    }
    
    
    
}
