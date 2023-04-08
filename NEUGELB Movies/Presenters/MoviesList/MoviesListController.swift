//
//  MoviesListController.swift
//  NEUGELB Movies
//
//  Created by Raj S on 06/04/23.
//

import UIKit
import Combine

class MoviesListController: UIViewController {
    
    private let viewModel: MoviesListViewModel
    private var dataSource: UICollectionViewDiffableDataSource<MovieListSection, MovieListItem>!
    private var subscribers: [AnyCancellable] = []
    private weak var nextButtonBottomConstraint: NSLayoutConstraint?
    
    private lazy var moviesListView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createMovieListLayout())
        collectionView.register(MoviesCell.self)
        collectionView.register(FavoritesMoviesCell.self)
        collectionView.register(MoviesHeaderview.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "MoviesHeaderview")
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 120, right: 0)
        return collectionView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .bordered()
        button.configurationUpdateHandler = { button in
            let isEnabled = button.isUserInteractionEnabled
            button.alpha = 1
            button.configuration?.baseBackgroundColor = isEnabled ? .systemBlue : .init(named: "disabledColor")
            button.configuration?.baseForegroundColor = isEnabled ? .white : .black.withAlphaComponent(0.35)
            button.configuration?.contentInsets = .init(top: 12,
                                                        leading: 120,
                                                        bottom: 12,
                                                        trailing: 120)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 8
            button.configuration?.cornerStyle = .large
            button.layer.borderColor = UIColor.black.cgColor
        }
        button.isUserInteractionEnabled = false
        button.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(didPressNext), for: .touchUpInside)
        return button
    }()
    
    
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = NSLocalizedString("Movies App", comment: "")
        view.addSubview(moviesListView)
        view.addSubview(nextButton)
        
        nextButtonBottomConstraint = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        NSLayoutConstraint.activate([
            moviesListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moviesListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nextButtonBottomConstraint!,
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        moviesListView.addRefreshControl(target: self, action: #selector(didPullToRefresh))
        
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
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let `self` = self else {
                return UICollectionReusableView()
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MoviesHeaderview", for: indexPath) as! MoviesHeaderview
            header.bind(with: self.viewModel.datasource[indexPath.section].title)
            return header
        }
        
        viewModel.$datasource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                guard let self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<MovieListSection, MovieListItem>()
                
                snapshot.appendSections(sections)
                
                for section in sections {
                    snapshot.appendItems(section.items,toSection: section)
                }
                
                self.dataSource.apply(snapshot, animatingDifferences: true,
                                      completion: { [weak self] in
                    guard let self else { return }
                    
                    self.handleSelectionIndexPath(for: self.viewModel.selectedMovie)
                })
                
                if !(sections.first?.items.first?.data.isLoader ?? false) {
                    self.moviesListView.endRefreshing()
                }
                
            }.store(in: &subscribers)
        
        
        viewModel.$selectedMovie
            .sink { [weak self] selectedMovie in
                guard let self else { return }
                
                self.updateNextButtonVisiblity(true, animate: true)
                self.handleSelectionIndexPath(for: selectedMovie)
                
            }
            .store(in: &subscribers)
        
        
        viewModel.$selectedMovie
            .map { $0 != nil }
            .sink { [weak self] isEnabled in
                guard let self else { return }
                
                self.nextButton.isUserInteractionEnabled = isEnabled
                self.nextButton.setNeedsUpdateConfiguration()
            }
            .store(in: &subscribers)
        
        
        viewModel.didViewLoaded()
    }
    
    @objc
    private func didPressNext() {
        viewModel.requestToOpenDetail()
    }
    
    @objc
    private func didPullToRefresh() {
        viewModel.requestToRefresh()
    }
    
    private func handleSelectionIndexPath(for selectedMovie: MovieCellViewModel?) {
        guard let selectedMovie = selectedMovie else {
            self.moviesListView.indexPathsForSelectedItems?.forEach {
                self.moviesListView.deselectItem(at: $0, animated: false)
            }
            return
        }
        
        var newSelectedIndexPaths: [IndexPath] = []
        
        if let indexPath = self.dataSource.indexPath(for: .movie(.data(value: selectedMovie))) {
            newSelectedIndexPaths.append(indexPath)
        }
        
        if let indexPath = self.dataSource.indexPath(for: .favotieMovie(.data(value: selectedMovie))) {
            newSelectedIndexPaths.append(indexPath)
        }
        
        let currentSelectedIndexPaths = self.moviesListView.indexPathsForSelectedItems?.filter { !newSelectedIndexPaths.contains($0) } ?? []
        
        currentSelectedIndexPaths.forEach {
            self.moviesListView.deselectItem(at: $0, animated: false)
        }
        
        newSelectedIndexPaths.forEach {
            self.moviesListView.selectItem(at: $0, animated: false,
                                           scrollPosition: .init(rawValue: 0))
        }
    }
    
}

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
    
    private func updateNextButtonVisiblity(_ visible: Bool, animate: Bool) {
        guard let nextButtonBottomConstraint = nextButtonBottomConstraint else { return }
        let bottomPadding: CGFloat = visible ? -20 : 80
        
        guard nextButtonBottomConstraint.constant != bottomPadding else { return }
        
        nextButtonBottomConstraint.constant = bottomPadding
        
        if animate {
            UIView.animate(withDuration: visible ? 0.3 : 0.5,
                           delay: visible ? 0.25 : 0,
                           animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
        } else {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
}

private extension MoviesListController {
    
    func createMovieListLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            if sectionIndex == 0 {
                return self.getHorizontalCollectionLayoutSection()
            } else {
                return self.getVerticalCollectionLayoutSection()
            }
        }
        
        return layout
    }
    
    func getHorizontalCollectionLayoutSection() -> NSCollectionLayoutSection {
        let itemFitInScreen: CGFloat = 4
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/itemFitInScreen),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                                          heightDimension: .absolute(MoviesCell.Small.shared.estimatedHeight)),
                                                       repeatingSubitem: item,
                                                       count: Int(itemFitInScreen)
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(54))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func getVerticalCollectionLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(MoviesCell.Large.shared.estimatedHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     repeatingSubitem: item,
                                                     count: 1)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16,
                                                        bottom: 0, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(54))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
}
