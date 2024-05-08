//
//  Recipe.swift
//  Reciplease
//
//  Created by Thomas Carlier on 07/05/2024.
//

import Foundation

struct Recipe: Decodable {
    var label: String
    var image: String
    var url: String
    var yield: Int
    var ingredientLines: [String]
    var totalTime: Int
}
