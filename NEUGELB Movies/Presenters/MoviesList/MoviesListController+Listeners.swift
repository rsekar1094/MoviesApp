//
//  MoviesListController+Listeners.swift
//  NEUGELB Movies
//
//  Created by Raj S on 08/04/23.
//

import Foundation

// MARK: - MoviesListController + Listeners
extension MoviesListController {
    func setUpListeners() {
        listenToDatasource()
        listenToSelectedMovie()
        listenToNextButtonEnabled()
        listenToAlertData()
    }
}

private extension MoviesListController {
    
    func listenToDatasource() {
        viewModel.$datasource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                guard let self else { return }
                
                self.reloadList(for: sections)
                
                if let isLoader = sections.first?.items.first?.data.isLoader,
                   isLoader {
                    self.moviesListView.endRefreshing()
                }
            }
            .store(in: &subscribers)
        
    }
    
    func listenToSelectedMovie() {
        viewModel.$selectedMovie
            .sink { [weak self] selectedMovie in
                guard let self else { return }
                
                self.updateNextButtonVisiblity(true, animate: true)
                self.handleSelectionState(for: selectedMovie)
                
            }
            .store(in: &subscribers)
    }
    
    func listenToNextButtonEnabled() {
        viewModel.$selectedMovie
            .map { $0 != nil }
            .sink { [weak self] isEnabled in
                guard let self else { return }
                
                self.nextButton.isUserInteractionEnabled = isEnabled
                self.nextButton.setNeedsUpdateConfiguration()
            }
            .store(in: &subscribers)
    }
    
    func listenToAlertData() {
        viewModel.alertToShow
            .sink { [weak self] alertData in
                guard let self else { return }
                self.show(alert: alertData)
            }
            .store(in: &subscribers)
    }
}
