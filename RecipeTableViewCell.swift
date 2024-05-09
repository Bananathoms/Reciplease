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
    @IBOutlet weak var recipeInfo: InfoView!
}
