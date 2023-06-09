//
//  MovieDetailViewController.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import UIKit

// MARK: - MovieDetailViewController
class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: MovieDetailViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, MovieDetailItem>!

    @Inject
    private var theme: Theme

    // MARK: - Views
    private lazy var moviesListView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createMovieListLayout())
        collectionView.register(MoviesCell.self)
        collectionView.register(MovieDetailValueCell.self)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsSelection = false
        return collectionView
    }()
    
    // MARK: - Initializers
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}
// MARK: - Details
private extension MovieDetailViewController {
    func setUp() {
        title = NSLocalizedString("Movies Details", comment: "")
        view.addSubview(moviesListView)
        NSLayoutConstraint.activate([
            moviesListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moviesListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        assignDatasource()
        reload()
    }
    
    func assignDatasource() {
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
    }
    
    func reload() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MovieDetailItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.items,toSection: 0)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}
// MARK: - Movies Layout
private extension MovieDetailViewController {
    func createMovieListLayout() -> UICollectionViewCompositionalLayout {
        let theme = self.theme
        let layout = UICollectionViewCompositionalLayout() { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false
           
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            section.contentInsets.leading = self.view.safeAreaInsets.left + theme.dimension.paddingM
            section.contentInsets.trailing = self.view.safeAreaInsets.right + theme.dimension.paddingM
            return section
        }
        return layout
    }
}
