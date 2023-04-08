//
//  MoviesListController+Util.swift
//  NEUGELB Movies
//
//  Created by Raj S on 08/04/23.
//

import UIKit

// MARK: - MoviesListController + NextButton
extension MoviesListController {
    func updateNextButtonVisiblity(_ visible: Bool, animate: Bool) {
        guard let nextButtonBottomConstraint = nextButtonBottomConstraint else { return }
        
        let bottomPadding: CGFloat = visible ? -20 : 80
        
        guard nextButtonBottomConstraint.constant != bottomPadding else { return }
        
        nextButtonBottomConstraint.constant = bottomPadding
        
        if animate {
            UIView.animate(withDuration: visible ? 0.2 : 0.5,
                           delay: visible ? 0.55 : 0,
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

// MARK: - MoviesListController + Selection
extension MoviesListController {
 
    func handleSelectionState(for selectedMovie: MovieCellViewModel?) {
        let currentSelectedItems = moviesListView.indexPathsForSelectedItems ?? []
        guard let selectedMovie = selectedMovie else {
            moviesListView.deselectItems(at: currentSelectedItems)
            return
        }
        
        let newSelectedIndexPaths: [IndexPath] = getIndexPaths(for: selectedMovie)
        let removeIndexPaths = currentSelectedItems.filter { !newSelectedIndexPaths.contains($0) }
        
        moviesListView.deselectItems(at: removeIndexPaths)
        moviesListView.selectItems(at: newSelectedIndexPaths)
    }
    
    
    private func getIndexPaths(for selectedMovie: MovieCellViewModel) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        
        // Retrive the movie indexPath from watched/to watch section
        if let indexPath = self.dataSource.indexPath(for: .movie(.data(value: selectedMovie))) {
            indexPaths.append(indexPath)
        }
        
        // Retrive the movie indexPath from favorie section
        if let indexPath = self.dataSource.indexPath(for: .favotieMovie(.data(value: selectedMovie))) {
            indexPaths.append(indexPath)
        }
        
        return indexPaths
    }
    
}


// MARK: - MoviesListController + Setup View
extension MoviesListController {
    func setUpView() {
        title = NSLocalizedString("Movies App", comment: "")
        view.addSubview(moviesListView)
        view.addSubview(nextButton)
        
        nextButtonBottomConstraint = nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                        constant: -20)
        NSLayoutConstraint.activate([
            moviesListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moviesListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nextButtonBottomConstraint!,
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
