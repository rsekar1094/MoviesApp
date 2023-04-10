//
//  Font.swift
//  NEUGELB Movies
//
//  Created by Rajasekhar Rajendran on 10.04.23.
//

import UIKit

// MARK: - ThemeFont
protocol ThemeFont {
    var listTitle: UIFont { get }
    var listValue: UIFont { get }
    var listHeader: UIFont { get }
}

// MARK: - ThemeFontImpl
struct ThemeFontImpl: ThemeFont {
    var listTitle: UIFont { UIFont.systemFont(ofSize: 18, weight: .medium) }
    var listValue: UIFont { UIFont.systemFont(ofSize: 16, weight: .regular) }
    var listHeader: UIFont { UIFont.systemFont(ofSize: 20, weight: .bold) }
}
