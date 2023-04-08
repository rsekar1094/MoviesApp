//
//  NetworkResponse.swift
//  NEUGELB Movies
//
//  Created by Raj S on 06/04/23.
//

import Foundation

// MARK: - NetworkResponse
struct NetworkResponse<T: Decodable>: Decodable {
    let results: T
}
