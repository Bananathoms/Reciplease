//  DetailedRecipeViewController.swift
//  Reciplease
//
//  Created by Thomas Carlier on 26/04/2024.
//

import Foundation
import UIKit

/// This ViewController handles the display of detailed information about a specific recipe.
class DetailedRecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var detailedRecipeImage: UIImageView!
    @IBOutlet weak var detailedRecipename: UILabel!
    @IBOutlet weak var detailedRecipeInfo: InfoView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var directionButton: UIButton!
    
    /// Contains detailed information about the recipe passed from the previous ViewController.
    var recipeDetail: RecipeResult?
    
    /// Sets up the tableView delegates and updates the UI with the recipe details on view load.
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.ingredientsTableView.dataSource = self
        self.ingredientsTableView.delegate = self

        self.updateUI()
    }
    
    /// Updates the UI elements with the data from `recipeDetail`. It populates the image, name, and other recipe info.
    func updateUI() {
        guard let recipeDetail = recipeDetail else { return }
        
        // Mise à jour des détails de la recette
        self.detailedRecipename.text = recipeDetail.label
        self.detailedRecipeInfo.labelTimeRecipe.text = "\(recipeDetail.totalTime) min"
        self.detailedRecipeInfo.labelLike.text = "\(recipeDetail.yield)"

        // Charger l'image à partir de l'URL si possible
        if let imageUrl = URL(string: recipeDetail.image) {
            self.detailedRecipeImage.loadImage(from: imageUrl)
        }

        // Recharger les données de la tableView
        self.ingredientsTableView.reloadData()
    }

    /// Returns the number of rows in a section; here it corresponds to the number of ingredients in the recipe.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Retourner le nombre d'ingrédients
        return self.recipeDetail?.ingredientLines.count ?? 0
    }
    
    /// Provides the cell for each row, populating it with the ingredient line from the recipe.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)

        cell.textLabel?.text = self.recipeDetail?.ingredientLines[indexPath.row]

        return cell
    }

    /// Opens the recipe's source URL in a web browser when the directions button is tapped, allowing users to view detailed cooking instructions.
    @IBAction func directionButtonTapped(_ sender: UIButton) {
        // Ouvrir l'URL de la source de la recette pour des instructions détaillées
        if let url = self.recipeDetail?.url, let urlToOpen = URL(string: url) {
            UIApplication.shared.open(urlToOpen)
        }
    }
}
