//
//  APIResponse.swift
//  Reciplease
//
//  Created by Thomas Carlier on 07/05/2024.
//

import Foundation

struct APIResponse: Decodable {
    let hits: [Hit]
    let count: Int
}

struct Hit: Decodable {
    let recipe: Recipe
}
