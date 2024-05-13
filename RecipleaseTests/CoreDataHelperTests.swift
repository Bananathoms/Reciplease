//
//  CoreDataHelperTests.swift
//  RecipleaseTests
//
//  Created by Thomas Carlier on 13/05/2024.
//

import Foundation
import XCTest
import CoreData
@testable import Reciplease

class CoreDataHelperTests: XCTestCase {
    var coreDataHelper: CoreDataHelper!
    var mockCoreDataStack: MockCoreDataStack!

    override func setUp() {
        super.setUp()

        // Initialiser le mock core data stack
        mockCoreDataStack = MockCoreDataStack()
        CoreDataStack.shared = mockCoreDataStack 
        
        coreDataHelper = CoreDataHelper.shared
    }

    override func tearDown() {
        coreDataHelper = nil
        mockCoreDataStack = nil
        super.tearDown()
    }

    func testAddFavorite_ShouldSaveRecipe() {
        let recipe = RecipeResult(label: "Test Recipe", image: "image_url", url: "recipe_url", ingredientLines: ["Ingredient1", "Ingredient2"], totalTime: 30)

        coreDataHelper.addFavorite(recipe: recipe)

        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        let results = try! coreDataHelper.context.fetch(fetchRequest)

        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.label, "Test Recipe")
    }

    func testRemoveFavorite_ShouldRemoveRecipe() {
        testAddFavorite_ShouldSaveRecipe()
        coreDataHelper.removeFavorite(recipeUrl: "recipe_url")

        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        let results = try! coreDataHelper.context.fetch(fetchRequest)

        XCTAssertTrue(results.isEmpty)
    }

    func testFetchFavorites_ShouldReturnAllFavorites() {
        let recipe1 = RecipeResult(label: "Test Recipe", image: "image_url", url: "recipe_url", ingredientLines: ["Ingredient1"], totalTime: 30)
        let recipe2 = RecipeResult(label: "Another Test Recipe", image: "another_image_url", url: "another_recipe_url", ingredientLines: ["Ingredient2"], totalTime: 25)

        coreDataHelper.addFavorite(recipe: recipe1)
        coreDataHelper.addFavorite(recipe: recipe2)

        let results = coreDataHelper.fetchFavorites()

        XCTAssertEqual(results.count, 2)
    }
}


