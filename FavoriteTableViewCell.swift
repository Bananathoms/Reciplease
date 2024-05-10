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
    @IBOutlet weak var favoriteRecipeInfo: InfoView!
}
