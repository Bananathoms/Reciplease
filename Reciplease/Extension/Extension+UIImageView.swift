//
//  Extension+UIImageView.swift
//  Reciplease
//
//  Created by Thomas Carlier on 09/05/2024.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// Loads an image from a specified URL and sets it to the UIImageView.
    /// - Parameter url: Optional URL from which to fetch the image.
    func loadImage(from url: URL?) {
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Failed to load image from URL: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
