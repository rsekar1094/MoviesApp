//
//  Movies.swift
//  NEUGELB Movies
//
//  Created by Raj S on 06/04/23.
//

import Foundation

// MARK: - Movie
struct Movie: Codable, Comparable, Hashable {
    let id: Int
    let title: String
    let originalLanguage: Language
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, backdropPath: String
    let releaseDate: String
    let rating: Double
    let isWatched: Bool

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, rating, isWatched
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Movie, rhs: Movie) -> Bool {
        if lhs.rating != rhs.rating {
            return lhs.rating > rhs.rating
        } else {
            return lhs.originalTitle < rhs.originalTitle
        }
    }
}

// MARK: - Language
struct Language: Codable {
    let code: String
    let name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        self.code = code
        self.name = Locale(identifier: code).localizedString(forLanguageCode: code)?.localizedCapitalized ?? code
    }
}
