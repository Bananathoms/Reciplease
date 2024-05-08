//
//  Extension+UIViewController.swift
//  Reciplease
//
//  Created by Thomas Carlier on 08/05/2024.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Displays an alert dialog with a title and message.
    /// - Parameters:
    ///   - title: The title of the alert. Defaults to "Notice" if no title is provided.
    ///   - message: The descriptive message that provides more details about the alert.
    func showAlert(title: String = "Notice", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
