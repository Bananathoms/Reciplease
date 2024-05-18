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
    @IBOutlet weak var labelTimeRecipe: UILabel!
    @IBOutlet weak var imageTime: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupAppearance()
    }

    private func setupAppearance() {
        self.layer.cornerRadius = 8
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor

        self.layer.masksToBounds = true
    }
}
