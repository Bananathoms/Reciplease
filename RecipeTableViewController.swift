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
    
    /// Configures the view once it is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Vous pourriez vouloir configurer d'autres éléments de l'interface utilisateur ici
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
        // Le nombre de lignes est égal au nombre de recettes
        return recipes.count
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
        cell.recipeImage.loadImage(from: URL(string: recipe.image))
        cell.recipeInfo.labelTimeRecipe.text = "\(recipe.totalTime) min"
        cell.recipeInfo.labelLike.text = "\(recipe.yield)"

        return cell
    }
}
