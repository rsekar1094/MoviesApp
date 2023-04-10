//
//  Color.swift
//  NEUGELB Movies
//
//  Created by Rajasekhar Rajendran on 10.04.23.
//

import UIKit

// MARK: - ThemeColor
protocol ThemeColor {
    var primaryTint: UIColor { get }
    var primaryText: UIColor { get }

    var background: UIColor { get }

    var disableSurface: UIColor { get }
    var disableContent: UIColor { get }

    var white: UIColor { get }

    var shimmeringColors: [UIColor] { get }
}

// MARK: - ThemeColorImpl
struct ThemeColorImpl: ThemeColor {
    var primaryTint: UIColor { return .systemBlue }
    var primaryText: UIColor { return .init(named: "primaryText")! }

    var background: UIColor { .systemBackground }

    var disableSurface: UIColor { return .init(named: "disabledColor")! }
    var disableContent: UIColor { return .black.withAlphaComponent(0.35) }

    var white: UIColor { return .white }

    var shimmeringColors: [UIColor] {
        let firstColor = UIColor(dynamicProvider: { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor.gray
            } else {
                return UIColor(white: 0.85, alpha: 1.0)
            }
        })

        let secondColor = UIColor(dynamicProvider: { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor.darkGray
            } else {
                return UIColor(white: 0.95, alpha: 1.0)
            }
        })

        return [firstColor,secondColor,firstColor]
    }
}
