//
//  BackdropImageView.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import UIKit

// MARK: - Setup
class BackdropImageView: UIImageView {

    // MARK: - State
    enum State {
        case shimmering
        case loaded
    }

    // MARK: - Properties
    var currentState: State = .shimmering {
        didSet {
            configureUI()
        }
    }

    // MARK: - Layers
    private lazy var overlay: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.75).cgColor
        layer.frame = bounds
        return layer
    }()

    private lazy var shimmeringLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        let gradientColorOne : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        let gradientColorTwo : CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        return gradientLayer
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
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        shimmeringLayer.frame = bounds
        overlay.frame = bounds
    }
    
    // MARK: - Methods
    private func setUp() {
        layer.addSublayer(overlay)
        layer.addSublayer(shimmeringLayer)
    }

    private func configureUI() {
        switch currentState {
        case .shimmering:
            shimmeringLayer.opacity = 1
            overlay.opacity = 0
            startShimmering()
        case .loaded:
            overlay.opacity = 1
            shimmeringLayer.opacity = 0
            stopShimmering()
        }
    }

    private func startShimmering() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.9
        shimmeringLayer.add(animation, forKey: animation.keyPath)
    }

    private func stopShimmering() {
        shimmeringLayer.removeAllAnimations()
    }
}
