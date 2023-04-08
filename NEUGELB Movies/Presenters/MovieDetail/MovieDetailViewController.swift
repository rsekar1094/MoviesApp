//
//  MovieDetailViewController.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    private let viewModel: MovieDetailViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, MovieDetailItem>!
    
    private lazy var moviesListView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createMovieListLayout())
        collectionView.register(MoviesCell.self)
        collectionView.register(MovieDetailValueCell.self)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Movies Details", comment: "")
        view.addSubview(moviesListView)
        NSLayoutConstraint.activate([
            moviesListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moviesListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        dataSource = UICollectionViewDiffableDataSource<Int, MovieDetailItem>(collectionView: moviesListView) { collectionView, indexPath, item in
            switch item {
            case .header(let data):
                let cell = collectionView.dequeue(MoviesCell.self, for: indexPath)
                cell.bind(with: .data(value: data))
                return cell
            case .data(let title, let value):
                let cell = collectionView.dequeue(MovieDetailValueCell.self, for: indexPath)
                cell.bind(title: title, value: value)
                return cell
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, MovieDetailItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.items,toSection: 0)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}
private extension MovieDetailViewController {
    func createMovieListLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout() { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false
           
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            section.contentInsets.leading = self.view.safeAreaInsets.left + 16
            section.contentInsets.trailing = self.view.safeAreaInsets.right + 16
            return section
        }
        return layout
    }
}
