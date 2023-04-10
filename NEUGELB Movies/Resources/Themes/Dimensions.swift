//
//  Dimensions.swift
//  NEUGELB Movies
//
//  Created by Rajasekhar Rajendran on 10.04.23.
//

import Foundation

// MARK: - ThemeDimension
protocol ThemeDimension {
    var paddingS: CGFloat { get }
    var paddingM: CGFloat { get }
    var paddingL: CGFloat { get }

    func cornerRadius(_ factor: CGFloat) -> CGFloat
    func base(_ factor: CGFloat) -> CGFloat
}

// MARK: - ThemeDimensionImpl
struct ThemeDimensionImpl: ThemeDimension {
    var paddingS: CGFloat { return 8 }
    var paddingM: CGFloat { return 16 }
    var paddingL: CGFloat { return 24 }

    func cornerRadius(_ factor: CGFloat) -> CGFloat {
        return factor * 8
    }

    func base(_ factor: CGFloat) -> CGFloat {
        return factor * 8
    }
}
