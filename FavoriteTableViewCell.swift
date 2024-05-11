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
}
