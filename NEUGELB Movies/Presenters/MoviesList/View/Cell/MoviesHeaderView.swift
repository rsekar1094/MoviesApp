//
//  MoviesHeaderView.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import UIKit

// MARK: - MoviesHeaderview
class MoviesHeaderview: UICollectionReusableView {

    // MARK: - Properties
    @Inject
    private var theme: Theme

    // MARK: - Views
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = theme.color.primaryText
        label.textAlignment = .left
        label.font = theme.font.listHeader
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    // MARK: - Bind
    func bind(with headerText: String) {
        headerLabel.text = headerText
    }
    
    // MARK: - Setup
    private func setUp() {
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                constant: -theme.dimension.base(1.2))
        ])
    }
}
