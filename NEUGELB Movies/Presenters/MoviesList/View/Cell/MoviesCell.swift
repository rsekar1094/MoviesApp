//
//  MoviesCell.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import UIKit

// MARK: - MoviesCell
class MoviesCell: UICollectionViewCell {
    
    // MARK: - Views
    private lazy var backdropImageView: BackdropImageView = {
        let imageView = BackdropImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = config.backdropCornerRadius
        return imageView
    }()

    private lazy var movieContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = config.movieContainerAxis
        stackView.spacing = config.containerSpace
        return stackView
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = theme.color.white
        label.font = theme.font.listTitle
        label.textAlignment = config.titleAlignment
        return label
    }()
    
    // MARK: - Properties
    var config: MoviesCellConfig { return Large.shared }

    @Inject
    private var theme: Theme
    
    override var isSelected: Bool {
        didSet {
            updateSelection()
        }
    }
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
        updateSelection()
    }
    
    // MARK: - Bind
    func bind(with viewModel: CellViewModel<MovieCellViewModel>) {
        switch viewModel {
        case .loading:
            reset()
        case .data(let movie):
            movieNameLabel.text = movie.name
            movieImageView.setImage(for: movie.posterImagePath)
            backdropImageView.setImage(for: movie.backdropImagePath)
            backdropImageView.currentState = .loaded
        }
        updateSelection()
    }

    private func updateSelection() {
        contentView.layer.borderWidth = isSelected ? 5 : 0
    }

    private func reset() {
        movieNameLabel.text = ""
        movieImageView.image = nil
        backdropImageView.image = nil
        backdropImageView.currentState = .shimmering
    }
    
}
// MARK: - Setup
private extension MoviesCell {
    func setUp() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.layer.cornerRadius = config.backdropCornerRadius
        contentView.layer.borderColor = theme.color.primaryTint.cgColor
        
        contentView.addSubview(backdropImageView)
        contentView.addSubview(movieContainer)
        
        let imageViewContainer = UIView()
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        movieContainer.addArrangedSubview(imageViewContainer)
        movieContainer.addArrangedSubview(movieNameLabel)
        
        imageViewContainer.addSubview(movieImageView)
        
        setUpConstraints(imageViewContainer: imageViewContainer)
    }
    
    func setUpConstraints(imageViewContainer: UIView) {
        var constraints: [NSLayoutConstraint] = [
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        
            movieContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: config.paddingAroundContainer),
            movieContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -config.paddingAroundContainer),
            movieContainer.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: config.paddingAroundContainer),
            movieContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                    constant: -config.paddingAroundContainer),
            
            movieImageView.widthAnchor.constraint(lessThanOrEqualToConstant: config.movieImageSize),
            movieImageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            movieImageView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor),
            movieImageView.heightAnchor.constraint(equalTo: movieImageView.widthAnchor),
        ]
        
        switch config.movieContainerAxis {
        case .horizontal:
            constraints.append(imageViewContainer.widthAnchor.constraint(equalTo: movieImageView.widthAnchor, multiplier: 1.0))
            constraints.append(imageViewContainer.heightAnchor.constraint(equalTo: movieImageView.heightAnchor,
                                                                          multiplier: 1.0))
        case .vertical:
            constraints.append(imageViewContainer.widthAnchor.constraint(greaterThanOrEqualTo: movieImageView.widthAnchor,
                                                                         multiplier: 1.0))
            constraints.append(imageViewContainer.heightAnchor.constraint(equalTo: movieImageView.heightAnchor,
                                                                          multiplier: 1.0))
        @unknown default:
            fatalError("Handle the unknown case")
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - MoviesCellConfig
protocol MoviesCellConfig {
    var movieContainerAxis: NSLayoutConstraint.Axis { get }
    var titleAlignment: NSTextAlignment { get }
    var movieImageSize: CGFloat { get }
    var containerSpace: CGFloat { get }
    var paddingAroundContainer: CGFloat { get }
    var backdropCornerRadius: CGFloat { get }
}

// MARK: - MoviesCell + Config
extension MoviesCell {
    struct Small: MoviesCellConfig {
        static let shared = Self()

        @Inject
        private var theme: Theme

        let movieContainerAxis: NSLayoutConstraint.Axis = .vertical
        let titleAlignment: NSTextAlignment = .center
        var movieImageSize: CGFloat { return theme.dimension.base(9.5) }
        var containerSpace: CGFloat { return theme.dimension.base(0.6) }
        var paddingAroundContainer: CGFloat { return theme.dimension.paddingS }
        var backdropCornerRadius: CGFloat { return theme.dimension.cornerRadius(1) }
        var estimatedHeight: CGFloat { return movieImageSize + (2 * paddingAroundContainer)  + theme.dimension.base(6) }
    }
    
    struct Large: MoviesCellConfig {
        static let shared = Self()

        @Inject
        private var theme: Theme

        let movieContainerAxis: NSLayoutConstraint.Axis = .horizontal
        let titleAlignment: NSTextAlignment = .left
        var movieImageSize: CGFloat { return theme.dimension.base(9) }
        var containerSpace: CGFloat { return theme.dimension.base(1.5) }
        var paddingAroundContainer: CGFloat { return theme.dimension.base(1.2) }
        var backdropCornerRadius: CGFloat { return theme.dimension.cornerRadius(1.5) }
        var estimatedHeight: CGFloat { return movieImageSize + (2 * paddingAroundContainer) }
    }
}
