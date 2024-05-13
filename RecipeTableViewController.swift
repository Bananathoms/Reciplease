//
//  RecipeTableViewController.swift
//  Reciplease
//
//  Created by Thomas Carlier on 26/04/2024.
//

import Foundation
import UIKit

/// Manages the display of recipes in a list format.
class RecipeTableViewController: UITableViewController {
    
    /// An array to store `RecipeResult` objects that are passed from the `SearchViewController`.
    var recipes: [RecipeResult] = []
    var nextPageURL: String?
    var isLoading = false
    let recipeService = RecipeService()
    
    
    /// Configures the view once it is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    /// Loads additional recipes from the next page URL if available.
    func loadMoreRecipes() {
        guard let nextPageURL = nextPageURL, let url = URL(string: nextPageURL) else { return }
        
        self.recipeService.fetchRecipes(from: url) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (newRecipes, nextPage)):
                    self?.recipes.append(contentsOf: newRecipes)
                    self?.nextPageURL = nextPage
                    self?.isLoading = false
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to load more recipes:", error)
                }
            }
        }
    }
    
    /// Returns the number of sections in the table view.
    /// - Parameter tableView: The table view requesting this information.
    /// - Returns: The number of sections in the table view.
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Une seule section est nécessaire pour cet exemple
        return 1
    }
    
    /// Determines the number of rows in a given section.
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - section: The index number of the section.
    /// - Returns: The number of rows in the section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    /// Determines the height of rows.
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: An index path locating the row in the table view.
    /// - Returns: the height of rows.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    /// - Parameters:
    ///   - tableView: The table view requesting the cell.
    ///   - indexPath: An index path locating the row in the table view.
    /// - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCellIdentifier", for: indexPath) as? RecipeTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecipeTableViewCell.")
        }

        let recipe = recipes[indexPath.row]
        cell.recipeNameLabel.text = recipe.label
        cell.recipeIngredientsLabel.text = recipe.ingredientLines.joined()
        cell.recipeImage.loadImage(from: URL(string: recipe.image))
        cell.recipeInfo.labelTimeRecipe.text = "\(recipe.totalTime) min"
        cell.recipeInfo.labelLike.text = "2,5k"

        return cell
    }
    
    /// Called when a row in the table view is selected.
    /// - Parameters:
    ///   - tableView:The table view containing the selected row.
    ///   - indexPath: The index path of the selected row.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailedRecipe", sender: indexPath)
    }
    
    /// Prepares for the segue to the detailed recipe view controller.
    /// - Parameters:
    ///   - segue: The segue object containing information about the view controllers involved in the segue.
    ///   - sender: The sender of the action triggering the segue. In this context, it is the index path of the selected row.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailedRecipe" {
            if let destinationVC = segue.destination as? DetailedRecipeViewController,
               let indexPath = sender as? IndexPath {
                destinationVC.recipeDetail = recipes[indexPath.row]
            }
        }
    }
    
    /// Notifies the view controller that a table view cell is about to be displayed.
    /// - Parameters:
    ///   - tableView:  The table view that is about to display the cell.
    ///   - cell: The cell that is about to be displayed.
    ///   - indexPath: The index path locating the row in the table view.
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == recipes.count - 1 {
            if let _ = nextPageURL, !isLoading {
                self.isLoading = true
                self.loadMoreRecipes()
            }
        }
    }
}
