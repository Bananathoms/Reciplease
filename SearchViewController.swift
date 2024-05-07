//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Thomas Carlier on 26/04/2024.
//

import Foundation
import UIKit

/// The `SearchViewController` is responsible for managing the user interactions related to searching recipes based on ingredients they input.
class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    /// TextField to enter ingredients.
    @IBOutlet weak var ingredientsTextField: UITextField!
    /// TableView to display the list of entered ingredients.
    @IBOutlet weak var ingredientsTableView: UITableView!

    /// An array to store the ingredients entered by the user.
    var ingredients: [String] = []
    
    /// Sets up the TableView data source, delegate and TextField delegate when the view loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientsTableView.dataSource = self
        self.ingredientsTableView.delegate = self
        self.ingredientsTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Hide the keyboard
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    /// Adds the ingredient from the TextField to the ingredients array and updates the TableView and clears the TextField after the ingredient is added.
    /// - Parameter sender: The button that triggers the action to add an ingredient.
    @IBAction func addIngredient(_ sender: UIButton) {
        guard let text = ingredientsTextField.text, !text.isEmpty else {
            return // Do not add empty strings to the ingredients list
        }
        self.ingredients.append(text)
        self.ingredientsTableView.reloadData()
        self.ingredientsTextField.text = ""
        self.ingredientsTextField.resignFirstResponder() // Hide the keyboard
    }
    
    /// Clears all ingredients from the array and updates the TableView to reflect this change.
    /// - Parameter sender: The button that triggers the action to clear all ingredients.
    @IBAction func clearIngredients(_ sender: UIButton) {
        ingredients.removeAll() // Vide la liste des ingrédients
        ingredientsTableView.reloadData() // Rafraîchit la tableView
    }
    
    /// Returns the number of rows needed for the TableView, which corresponds to the number of ingredients.
    /// - Parameters:
    ///   - tableView: The TableView that needs the number of rows.
    ///   - section: The section of the TableView (not used here as there's only one section).
    /// - Returns: The number of ingredients in the list.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    /// Configures each cell in the TableView to display an ingredient from the ingredients array.
    /// - Parameters:
    ///   - tableView: The TableView requesting the cell.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A configured cell with an ingredient's name.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = ingredients[indexPath.row]
        return cell
    }
}

