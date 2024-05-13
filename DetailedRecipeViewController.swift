//  DetailedRecipeViewController.swift
//  Reciplease
//
//  Created by Thomas Carlier on 26/04/2024.
//

import Foundation
import UIKit
import CoreData

/// This ViewController handles the display of detailed information about a specific recipe.
class DetailedRecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var detailedRecipeImage: UIImageView!
    @IBOutlet weak var detailedRecipename: UILabel!
    @IBOutlet weak var detailedRecipeInfo: InfoView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var favButton: UIBarButtonItem!
    
    
    /// Contains detailed information about the recipe passed from the previous ViewController.
    var recipeDetail: RecipeResult?
    /// Tracks whether the recipe is marked as a favorite.
    var isFavorite: Bool = false
    
    var context: NSManagedObjectContext {
        return CoreDataStack.shared.context
    }
    
    /// Sets up the tableView delegates and updates the UI with the recipe details on view load.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ingredientsTableView.dataSource = self
        self.ingredientsTableView.delegate = self
        
        self.checkIfRecipeIsFavorite()
        self.updateUI()
    }
    
    /// Adjusts the frame of the gradient layer on the recipe image after the view's subviews layout has been updated.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.detailedRecipeImage.layer.sublayers?.first { $0 is CAGradientLayer }?.frame = self.detailedRecipeImage.bounds
    }
    
    /// Checks if the current recipe is marked as a favorite in the CoreData database.
    func checkIfRecipeIsFavorite() {
        guard let recipe = self.recipeDetail else { return }
        
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", recipe.url)
        
        if let result = try? context.fetch(fetchRequest), result.count > 0 {
            self.isFavorite = true
        } else {
            self.isFavorite = false
        }
        self.updateFavoriteIcon()
    }
    
    /// Updates the UI elements with the data from `recipeDetail`. It populates the image, name, and other recipe info.
    func updateUI() {
        guard let recipeDetail = self.recipeDetail else { return }
        
        self.detailedRecipename.text = recipeDetail.label
        self.detailedRecipeInfo.labelTimeRecipe.text = "\(recipeDetail.totalTime) min"
        self.detailedRecipeInfo.labelLike.text = "2,5k"
        
        if let imageUrl = URL(string: recipeDetail.image) {
            self.detailedRecipeImage.loadImage(from: imageUrl)
            self.detailedRecipeImage.addGradientLayer(frame: detailedRecipeImage.bounds, endColor: .background)
        }
        self.ingredientsTableView.reloadData()
    }
    
    /// Updates the favorite button icon based on the `isFavorite` state.
    func updateFavoriteIcon() {
        if self.isFavorite {
            self.favButton.image = UIImage(systemName: "star.fill")
        } else {
            self.favButton.image = UIImage(systemName: "star")
        }
    }
    
    /// Returns the number of rows in a section; here it corresponds to the number of ingredients in the recipe.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Retourner le nombre d'ingrédients
        return self.recipeDetail?.ingredientLines.count ?? 0
    }
    
    /// Provides the cell for each row, populating it with the ingredient line from the recipe.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell as an instance of IngredientsDetailTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsDetailCellIdentifier", for: indexPath) as? IngredientsDetailTableViewCell else {
            fatalError("The dequeued cell is not an instance of IngredientsDetailTableViewCell.")
        }
        cell.ingredientsNameLabel.text = "- \(self.recipeDetail?.ingredientLines[indexPath.row] ?? "No ingredient")"
        return cell
    }
    
    /// Opens the recipe's source URL in a web browser when the directions button is tapped, allowing users to view detailed cooking instructions.
    @IBAction func directionButtonTapped(_ sender: UIButton) {
        // Ouvrir l'URL de la source de la recette pour des instructions détaillées
        if let url = self.recipeDetail?.url, let urlToOpen = URL(string: url) {
            UIApplication.shared.open(urlToOpen)
        }
    }
    
    /// Toggles the favorite state of the recipe when the favorite button is tapped, updating the icon accordingly.
    @IBAction func favButtonTapped(_ sender: UIBarButtonItem) {
        guard let recipe = self.recipeDetail else { return }
        if isFavorite {
            CoreDataHelper.shared.removeFavorite(recipeUrl: recipe.url)
        } else {
            CoreDataHelper.shared.addFavorite(recipe: recipe)
        }
        self.isFavorite.toggle()
        self.updateFavoriteIcon()
    }
}
