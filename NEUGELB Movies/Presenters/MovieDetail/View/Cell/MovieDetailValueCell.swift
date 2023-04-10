//
//  MovieDetailValueCell.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import UIKit

// MARK: - MovieDetailValueCell
class MovieDetailValueCell: UICollectionViewCell {

    // MARK: - Properties
    @Inject
    private var theme: Theme

    // MARK: - Views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = theme.color.primaryText
        label.font = theme.font.listTitle
        label.textAlignment = .left
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = theme.color.primaryText
        label.font = theme.font.listValue
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    // MARK: - Bind
    func bind(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
// MARK: - Setup
private extension MovieDetailValueCell {
    func setUp() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
       
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5,
                                              constant: -theme.dimension.paddingS),
            titleLabel.topAnchor.constraint(equalTo: valueLabel.topAnchor),
            
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor,
                                                constant: theme.dimension.paddingS),
            valueLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: theme.dimension.paddingM),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -theme.dimension.paddingM)
        ])
    }
}
