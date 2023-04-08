//
//  Config.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import Foundation

// MARK: - Config
protocol Config {
    var apiBasePath: String { get }
    var imageBasePath: String { get }
}

// MARK: - ConfigImpl
class ConfigImpl: Config {
    var apiBasePath: String { return "https://61efc467732d93001778e5ac.mockapi.io" }
    var imageBasePath: String { return "https://image.tmdb.org/t/p" }
}
