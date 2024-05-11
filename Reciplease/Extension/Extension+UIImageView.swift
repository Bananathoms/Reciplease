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
    
    /// Adds a gradient layer to the UIView to create a fading color effect.
    /// - Parameters:
    ///   - frame: The CGRect defining the frame of the gradient layer, usually matching the bounds of the UIView it's applied to.
    ///   - colors: An array of UIColor objects representing the colors used in the gradient. Defaults to starting clear and ending in black.
    ///   - locations: An array of NSNumber objects defining the location of each color transition in the gradient. Defaults to start transitioning at 50% and fully black at 100%.
    func addBlackGradientLayer(frame: CGRect, colors: [UIColor] = [UIColor.clear, UIColor.black], locations: [NSNumber] = [0.5, 1.0]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
