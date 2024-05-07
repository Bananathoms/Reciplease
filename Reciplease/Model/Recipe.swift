//
//  Recipe.swift
//  Reciplease
//
//  Created by Thomas Carlier on 07/05/2024.
//

import Foundation

struct Recipe: Decodable {
    let id: String
    let title: String
    let ingredients: [String]
    let imageURL: URL
    let sourceURL: URL
}
