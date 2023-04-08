//
//  BackdropImageView.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import UIKit

// MARK: - Setup
class BackdropImageView: UIImageView {
    
    // MARK: - Views
    private lazy var overlay: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.withAlphaComponent(0.75).cgColor
        layer.frame = bounds
        return layer
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
        
        overlay.frame = bounds
    }
    
    // MARK: - Setup
    private func setUp() {
        layer.addSublayer(overlay)
    }
}
