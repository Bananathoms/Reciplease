//
//  CoreDataHelper.swift
//  Reciplease
//
//  Created by Thomas Carlier on 10/05/2024.
//

import Foundation
import CoreData
import UIKit

/// Manages the Core Data operations for the Reciplease app, including saving, adding, removing, and fetching favorite recipes.
class CoreDataHelper {

    static let shared = CoreDataHelper()

    private init() {}

    var context: NSManagedObjectContext {
        return CoreDataStack.shared.context
    }
    
    /// Saves any unsaved changes in the context to the persistent store.
    func saveContext() {
        CoreDataStack.shared.saveContext()
    }

    /// Adds a recipe to the favorites in CoreData.
    /// - Parameter recipe: The `RecipeResult` to save as a favorite.
    func addFavorite(recipe: RecipeResult) {
        let newFavorite = FavoriteRecipe(context: context)
        newFavorite.label = recipe.label
        newFavorite.image = recipe.image
        newFavorite.url = recipe.url
        newFavorite.totalTime = Int16(recipe.totalTime)
        newFavorite.yield = Int16(recipe.yield)
        newFavorite.ingredientLines = recipe.ingredientLines.joined(separator: ", ")

        do {
            try self.context.save()
        } catch {
            print("Failed to save favorite: \(error)")
        }
    }

    /// Removes a favorite recipe from CoreData.
    /// - Parameter recipeUrl: The `url` of the recipe to remove.
    func removeFavorite(recipeUrl: String) {
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", recipeUrl)

        if let result = try? context.fetch(fetchRequest), let objectToDelete = result.first {
            context.delete(objectToDelete)
            saveContext()
        }
    }

    /// Fetches all favorite recipes from CoreData.
    /// - Returns: An array of `FavoriteRecipe`.
    func fetchFavorites() -> [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        do {
            return try self.context.fetch(request)
        } catch {
            print("Error fetching favorite recipes: \(error)")
            return []
        }
    }
}
