//
//  MoviesListController.swift
//  NEUGELB Movies
//
//  Created by Raj S on 06/04/23.
//

import UIKit
import Combine

// MARK: - MoviesListController
class MoviesListController: UIViewController, Alertable {
    
    // MARK: - Properties
    let viewModel: MoviesListViewModel
    var dataSource: UICollectionViewDiffableDataSource<MovieListSection, MovieListItem>!
    var subscribers: [AnyCancellable] = []
    weak var nextButtonBottomConstraint: NSLayoutConstraint?

    @Inject
    private var theme: Theme
    
    // MARK: - Views
    lazy var moviesListView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: getMovieListLayout())
        collectionView.register(MoviesCell.self)
        collectionView.register(FavoritesMoviesCell.self)
        collectionView.register(MoviesHeaderview.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "MoviesHeaderview")
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 120, right: 0)
        return collectionView
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .bordered()
        let theme = self.theme
        button.configurationUpdateHandler = { button in
            let isEnabled = button.isUserInteractionEnabled
            button.alpha = 1
            button.configuration?.baseBackgroundColor = isEnabled ? theme.color.primaryTint : theme.color.disableSurface
            button.configuration?.baseForegroundColor = isEnabled ? theme.color.white : theme.color.disableContent
            let horizontalInset = theme.dimension.base(15)
            let verticalInset = theme.dimension.base(1.5)
            button.configuration?.contentInsets = .init(top: verticalInset,
                                                        leading: horizontalInset,
                                                        bottom: verticalInset,
                                                        trailing: horizontalInset)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = theme.dimension.cornerRadius(1)
            button.configuration?.cornerStyle = .large
            button.layer.borderColor = UIColor.black.cgColor
        }
        button.isUserInteractionEnabled = false
        button.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(didPressNext), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpListeners()
        setUpDiffableDataSource()
        moviesListView.addRefreshControl(target: self, action: #selector(didPullToRefresh))
        
        viewModel.didViewLoaded()
    }
    
    // MARK: - Actions
    @objc
    private func didPressNext() {
        viewModel.requestToOpenDetail()
    }
    
    @objc
    private func didPullToRefresh() {
        viewModel.requestToRefresh()
    }
}

// MARK: - CollectionView Delegates
extension MoviesListController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didSelected(item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return true }
        switch item.data {
        case .data(let movie):
            return viewModel.selectedMovie?.id != movie.id
        case .loading:
            return true
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        updateNextButtonVisiblity(false, animate: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        
        updateNextButtonVisiblity(true, animate: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateNextButtonVisiblity(true, animate: true)
    }
}

