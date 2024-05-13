//
//  RecipeResult.swift
//  Reciplease
//
//  Created by Thomas Carlier on 07/05/2024.
//

import Foundation

/// Represents a single recipe result as fetched from the recipe API.
struct RecipeResult: Decodable {
    var label: String /// The name or title of the recipe.
    var image: String /// URL string pointing to the image of the recipe.
    var url: String /// URL string linking to the detailed recipe page.
    var ingredientLines: [String] /// A list of ingredients used in the recipe.
    var totalTime: Int /// The total time required to prepare and cook the recipe, measured in minutes.
}
