//
//  RoundImageView.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import UIKit
class RoundImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.height / 2
        layer.masksToBounds = true
    }
    
}
