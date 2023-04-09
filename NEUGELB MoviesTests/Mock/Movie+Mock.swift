//
//  Movie+Mock.swift
//  NEUGELB MoviesTests
//
//  Created by Rajasekhar Rajendran on 09.04.23.
//

import Foundation
@testable import NEUGELB_Movies

extension Movie {
    static func getDummy(overview: String = "") -> Movie {
        return Movie(id: 9, title: "",
                     originalLanguage: .init(code: "", name: ""),
                     originalTitle: "",
                     overview: overview,
                     popularity: 2,
                     posterPath: "",
                     backdropPath: "",
                     releaseDate: "",
                     rating: 2, isWatched: false)
    }
}
