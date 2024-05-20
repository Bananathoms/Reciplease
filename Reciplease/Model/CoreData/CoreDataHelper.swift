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

    /// Adds a recipe to the favorites in CoreData and saves the associated image.
    /// - Parameter recipe: The `RecipeResult` to save as a favorite.
    func addFavorite(recipe: RecipeResult) {
        let newFavorite = FavoriteRecipe(context: context)
        newFavorite.label = recipe.label
        newFavorite.image = recipe.image
        newFavorite.url = recipe.url
        newFavorite.totalTime = Int16(recipe.totalTime)
        newFavorite.ingredientLines = recipe.ingredientLines.joined(separator: ", ")

        // Save the associated image
        if let imageUrl = URL(string: recipe.image) {
            downloadAndSaveImage(from: imageUrl, fileName: recipe.url)
        }

        do {
            try self.context.save()
        } catch {
            print("Failed to save favorite: \(error)")
        }
        NotificationCenter.default.post(name: .didUpdateFavorites, object: nil)
    }

    /// Removes a favorite recipe from CoreData and deletes the associated image.
    /// - Parameter recipeUrl: The `url` of the recipe to remove.
    func removeFavorite(recipeUrl: String) {
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", recipeUrl)

        if let result = try? context.fetch(fetchRequest), let objectToDelete = result.first {
            context.delete(objectToDelete)
            deleteImage(fileName: recipeUrl)
            saveContext()
        }
        NotificationCenter.default.post(name: .didUpdateFavorites, object: nil)
    }

    /// Fetches all favorite recipes from CoreData.
    /// - Returns: An array of `FavoriteRecipe`.
    func fetchFavorites() -> [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        do {
            let results = try self.context.fetch(request)
            return results
        } catch {
            print("Error fetching favorite recipes: \(error)")
            return []
        }
    }

    /// Downloads an image from the specified URL and saves it locally.
    /// - Parameters:
    ///   - url: The URL of the image to download.
    ///   - fileName: The name to use for the saved image file.
    private func downloadAndSaveImage(from url: URL, fileName: String) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Failed to download image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.saveImage(image: image, fileName: fileName)
        }.resume()
    }

    /// Saves an image to the local file system.
    /// - Parameters:
    ///   - image: The image to save.
    ///   - fileName: The name to use for the saved image file.
    func saveImage(image: UIImage, fileName: String) {
        if let data = image.pngData() {
            let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
            try? data.write(to: fileURL)
        }
    }

    /// Deletes an image from the local file system.
    /// - Parameter fileName: The name of the image file to delete.
    private func deleteImage(fileName: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }

    /// Loads an image from the local file system.
    /// - Parameter fileName: The name of the image file to load.
    /// - Returns: The loaded image, or nil if the image could not be loaded.
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
    }

    /// Returns the URL of the documents directory.
    /// - Returns: The URL of the documents directory.
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
