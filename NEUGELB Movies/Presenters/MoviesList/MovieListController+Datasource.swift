//
//  MovieListController+Datasource.swift
//  NEUGELB Movies
//
//  Created by Raj S on 08/04/23.
//

import UIKit

// MARK: - MoviesListController + Diffable
extension MoviesListController {
    func setUpDiffableDataSource() {
        configureDataSource()
        configureSupplementaryProvider()
    }
    
    func reloadList(for sections: [MovieListSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<MovieListSection, MovieListItem>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items,toSection: section)
        }
        self.dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            guard let self else { return }
            self.handleSelectionState(for: self.viewModel.selectedMovie)
        }
    }
}

private extension MoviesListController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MovieListSection, MovieListItem>(collectionView: moviesListView) { collectionView, indexPath, item in
            switch item {
            case .movie(let data):
                let cell = collectionView.dequeue(MoviesCell.self, for: indexPath)
                cell.bind(with: data)
                return cell
            case .favotieMovie(let data):
                let cell = collectionView.dequeue(FavoritesMoviesCell.self, for: indexPath)
                cell.bind(with: data)
                return cell
            }
        }
    }
    
    func configureSupplementaryProvider() {
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self else {
                return UICollectionReusableView()
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MoviesHeaderview", for: indexPath) as! MoviesHeaderview
            header.bind(with: self.viewModel.datasource[indexPath.section].title)
            return header
        }
    }
}
