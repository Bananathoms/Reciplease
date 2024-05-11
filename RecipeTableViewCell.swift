//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Thomas Carlier on 08/05/2024.
//

import Foundation
import UIKit

/// A custom table view cell designed to display detailed information about a recipe.
class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeIngredientsLabel: UILabel!
    @IBOutlet weak var recipeInfo: InfoView!
    
    /// Prepares the cell after it has been loaded from the Interface Builder.
    override func awakeFromNib() {
        super.awakeFromNib()
        self.recipeImage.addGradientLayer(frame: recipeImage.bounds, endColor: .black)
    }
    
    /// Updates the layout of the subviews when the cell's view undergoes layout changes.
    override func layoutSubviews() {
        super.layoutSubviews()
        self.recipeImage.layer.sublayers?.first(where: { $0 is CAGradientLayer })?.frame = self.recipeImage.bounds
    }
}
