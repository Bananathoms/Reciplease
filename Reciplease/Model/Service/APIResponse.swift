//
//  APIResponse.swift
//  Reciplease
//
//  Created by Thomas Carlier on 07/05/2024.
//

import Foundation

/// Represents the entire response from the recipe API.
struct APIResponse: Decodable {
    let from: Int
    let to: Int
    let count: Int
    let hits: [Hit]
    let _links: Links?
}

/// Represents links related to pagination in the API response.
struct Links: Decodable {
    let next: NextPage?
}

/// Detailed information about a pagination link.
struct NextPage: Decodable {
    let href: String
}

/// A structure used to model the individual elements in the `hits` array of the `APIResponse`.
struct Hit: Decodable {
    let recipe: RecipeResult
}
