//
//  MoviesListController+ListLayout.swift
//  NEUGELB Movies
//
//  Created by Raj S on 08/04/23.
//

import UIKit

// MARK: - MoviesListController + Layout
extension MoviesListController {
    func getMovieListLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) in
            guard let self,
                  let section = self.dataSource.sectionIdentifier(for: sectionIndex) else {
                return nil
            }
            
            return section.canScrollHorizontally ? self.getHorizontalSection() : self.getVerticalSection()
        }
    }
}

// MARK: - MoviesListController + Layout Types
private extension MoviesListController {
    
    func getHorizontalSection() -> NSCollectionLayoutSection {
        let itemFitInScreen: CGFloat = 4
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/itemFitInScreen),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(MoviesCell.Small.shared.estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: Int(itemFitInScreen))
        
        let section = getSection(for: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func getVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(MoviesCell.Large.shared.estimatedHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     repeatingSubitem: item,
                                                     count: 1)
        group.interItemSpacing = .fixed(10)
        
        let section = getSection(for: group)
        section.interGroupSpacing = 10
        return section
    }
    
    func getSection(for group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(54))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
}
