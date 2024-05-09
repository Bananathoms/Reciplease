//
//  InfoView.swift
//  Reciplease
//
//  Created by Thomas Carlier on 08/05/2024.
//

import Foundation
import UIKit

/// A custom UIView subclass designed to display specific recipe information, including likes and cooking time.
class InfoView: UIView{
    @IBOutlet weak var labelLike: UILabel!
    @IBOutlet weak var imageLike: UIImageView!
    @IBOutlet weak var labelTimeRecipe: UILabel!
    @IBOutlet weak var imageTime: UIImageView!
}
