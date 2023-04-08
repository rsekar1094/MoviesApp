//
//  UICollectionView+Selection.swift
//  NEUGELB Movies
//
//  Created by Raj S on 08/04/23.
//

import UIKit
extension UICollectionView {
    func selectItems(at indexPaths: [IndexPath], animated: Bool = false) {
        indexPaths.forEach {
            selectItem(at: $0, animated: animated, scrollPosition: .init(rawValue: 0))
        }
    }
    
    func deselectItems(at indexPaths: [IndexPath],animated: Bool = false) {
        indexPaths.forEach {
            deselectItem(at: $0, animated: animated)
        }
    }
}
