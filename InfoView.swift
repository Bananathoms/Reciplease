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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }

    private func setupAppearance() {
        // Arrondir les coins
        self.layer.cornerRadius = 8 // Ajustez cette valeur pour obtenir l'arrondi désiré
        
        // Ajouter une bordure
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor // Définir la couleur de la bordure ici

        // Pour s'assurer que l'arrondi s'applique correctement
        self.layer.masksToBounds = true
    }
}
