//
//  RecipeQuery.swift
//  Reciplease
//
//  Created by Thomas Carlier on 07/05/2024.
//

import Foundation

/// Represents a query to be sent to the recipe API.
struct RecipeQuery: Encodable {
    let q: String /// The search query string containing ingredients or keywords for recipes.
    let app_id: String /// The application ID used to authenticate requests to the API.
    let app_key: String /// The API key used to authenticate requests to the API.
}
