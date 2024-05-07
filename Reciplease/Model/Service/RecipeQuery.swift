//
//  RecipeQuery.swift
//  Reciplease
//
//  Created by Thomas Carlier on 07/05/2024.
//

import Foundation

struct RecipeQuery: Encodable {
    let q: String
    let app_id: String
    let app_key: String
}
