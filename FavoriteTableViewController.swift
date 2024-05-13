//
//  FavoriteTableViewController.swift
//  Reciplease
//
//  Created by Thomas Carlier on 06/05/2024.
//

import Foundation
import UIKit
import CoreData

/// Manages the display and interaction with the list of favorite recipes saved in CoreData.
class FavoriteTableViewController: UITableViewController {

    /// Array to store favorite recipes fetched from CoreData.
    var favoriteRecipes: [FavoriteRecipe] = []
    
    /// Sets up the view controller with necessary data loading and notification observation for updates.
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadFavoriteRecipes), name: .didUpdateFavorites, object: nil)
        self.loadFavoriteRecipes()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// /// Loads favorite recipes from CoreData and reloads the table view.
    @objc func loadFavoriteRecipes() {
        self.favoriteRecipes = CoreDataHelper.shared.fetchFavorites()
        tableView.reloadData()
    }
    
    /// Returns the number of rows in the section, corresponding to the number of favorite recipes.
    /// - Parameters:
    ///   - tableView: The table view requesting the information.
    ///   - section: An integer identifying a section in tableView.
    /// - Returns: The number of rows in the section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteRecipes.count
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    /// - Parameters:
    ///   - tableView: The table view requesting the cell.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCellIdentifier", for: indexPath) as? FavoriteTableViewCell else {
            fatalError("The dequeued cell is not an instance of FavoriteTableViewCell.")
        }

        let recipe = self.favoriteRecipes[indexPath.row]
        cell.favoriteRecipeNameLabel.text = recipe.label
        cell.favoriteRecipeIngredientsLabel.text = recipe.ingredientLines
        cell.favoriteRecipeInfo.labelTimeRecipe.text = "\(recipe.totalTime) min"
        cell.favoriteRecipeInfo.labelLike.text = "\(recipe.yield)"

        if let imageUrl = URL(string: recipe.image ?? "defaultImageUrl") {
            cell.favoriteRecipeImage.loadImage(from: imageUrl)
        } else {
            cell.favoriteRecipeImage.image = UIImage(named: "defaultImageName")
        }
        return cell
    }
    
    /// Determines the height of rows.
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: An index path locating the row in the table view.
    /// - Returns: the height of rows.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    /// Tells the delegate that the specified row is now selected and performs a segue.
    /// - Parameters:
    ///   - tableView: A table-view object informing the delegate about the new row selection.
    ///   - indexPath: An index path locating the new selected row in tableView.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowFavoriteDetailedRecipe", sender: self)
    }
    
    /// Prepares for the segue by sending selected recipe details to the destination view controller.
    /// - Parameters:
    ///   - segue: The segue object containing information about the view controllers involved in the segue.
    ///   - sender: The object that initiated the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFavoriteDetailedRecipe" {
            if let destinationVC = segue.destination as? DetailedRecipeViewController, let indexPath = tableView.indexPathForSelectedRow {
                let selectedRecipe = favoriteRecipes[indexPath.row]
                destinationVC.recipeDetail = convertFavoriteRecipeToRecipeResult(selectedRecipe)
            }
        }
    }
    
    /// Converts a `FavoriteRecipe` object into a `RecipeResult` object for seamless integration with the DetailedRecipeViewController.
    /// - Parameter favorite: The `FavoriteRecipe` object to convert.
    /// - Returns: A `RecipeResult` object containing the data from the `FavoriteRecipe`.
    func convertFavoriteRecipeToRecipeResult(_ favorite: FavoriteRecipe) -> RecipeResult {
        return RecipeResult(
            label: favorite.label ?? "",
            image: favorite.image ?? "",
            url: favorite.url ?? "",
            ingredientLines: favorite.ingredientLines?.components(separatedBy: ", ") ?? [],
            totalTime: Int(favorite.totalTime)
        )
    }
}
