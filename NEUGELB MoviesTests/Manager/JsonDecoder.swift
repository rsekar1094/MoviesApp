//
//  JsonDecoder.swift
//  NEUGELB MoviesTests
//
//  Created by Raj S on 08/04/23.
//

import Foundation
class JsonDecoder {
    func decode<T: Decodable>(for fileName: String) throws -> T  {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("Failed to find data.json file in main bundle.")
        }

        let jsonData = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
    
}
