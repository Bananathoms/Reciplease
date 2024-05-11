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
    
    /// Adds a gradient layer to the view with a customizable end color while starting with clear.
    /// - Parameters:
    ///   - frame: The frame on which the gradient layer will be applied.
    ///   - endColor: The color at the end of the gradient.
    ///   - locations: The location of each gradient stop.
    func addGradientLayer(frame: CGRect, endColor: UIColor, locations: [NSNumber] = [0.5, 1.0]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.clear.cgColor, endColor.cgColor]
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
