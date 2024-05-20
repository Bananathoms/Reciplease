//
//  FavoriteTableViewCell.swift
//  Reciplease
//
//  Created by Thomas Carlier on 10/05/2024.
//

import Foundation
import UIKit

/// A custom table view cell designed to display detailed information about a recipe.
class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var favoriteRecipeImage: UIImageView!
    @IBOutlet weak var favoriteRecipeNameLabel: UILabel!
    @IBOutlet weak var favoriteRecipeIngredientsLabel: UILabel!
    @IBOutlet weak var favoriteRecipeInfo: InfoView!
    
    /// Prepares the cell after it has been loaded from the Interface Builder.
    override func awakeFromNib() {
        super.awakeFromNib()
        self.favoriteRecipeImage.addGradientLayer(frame: favoriteRecipeImage.bounds, endColor: .black)
    }

    /// Updates the layout of the subviews when the cell's view undergoes layout changes.
    override func layoutSubviews() {
        super.layoutSubviews()
        self.favoriteRecipeImage.layer.sublayers?.first(where: { $0 is CAGradientLayer })?.frame = self.favoriteRecipeImage.bounds
    }
    
    /// Configures the cell with the favorite recipe data and loads the image from disk if available.
    func configure(with recipe: FavoriteRecipe) {
        self.favoriteRecipeNameLabel.text = recipe.label
        self.favoriteRecipeIngredientsLabel.text = recipe.ingredientLines
        self.favoriteRecipeInfo.labelTimeRecipe.text = "\(recipe.totalTime) min"
        
        if let imageUrl = recipe.image, let savedImage = CoreDataHelper.shared.loadImageFromDiskWith(fileName: imageUrl) {
            self.favoriteRecipeImage.image = savedImage
        } else {
            self.favoriteRecipeImage.image = UIImage(named: "defaultImageName")
        }
    }
}

