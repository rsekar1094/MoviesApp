//
//  NetworkManager.swift
//  NEUGELB Movies
//
//  Created by Raj S on 06/04/23.
//

import Foundation

// MARK: - NetworkManaging
protocol NetworkManaging {
    func fetch<T: Decodable>(path: String) async throws -> T
}

// MARK: - URLSessionNetworkManager
final class URLSessionNetworkManager: NetworkManaging {
    @Inject
    var config: Config
    
    func fetch<T: Decodable>(path: String) async throws -> T {
        guard let url = URL(string: config.apiBasePath + "/" + path) else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}

// MARK: - NetworkError
enum NetworkError: LocalizedError {
    case invalidUrl
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return NSLocalizedString("Invalid Url", comment: "")
        case .invalidResponse:
            return NSLocalizedString("Invalid Response", comment: "")
        }
    }
}
