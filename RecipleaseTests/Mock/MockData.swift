//
//  MockData.swift
//  RecipleaseTests
//
//  Created by Thomas Carlier on 13/05/2024.
//

import Foundation

struct MockData {
    static var recipesData: Data {
        let bundle = Bundle(for: RecipeServiceTests.self)
        let url = bundle.url(forResource: "MockRecipesResponse", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}
