//
//  APIResponse.swift
//  Reciplease
//
//  Created by Thomas Carlier on 07/05/2024.
//

import Foundation

/// Represents the entire response from the recipe API.
struct APIResponse: Decodable {
    let hits: [Hit]
    let count: Int
}

/// A structure used to model the individual elements in the `hits` array of the `APIResponse`.
struct Hit: Decodable {
    let recipe: RecipeResult
}
