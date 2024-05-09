//
//  RecipeService.swift
//  Reciplease
//
//  Created by Thomas Carlier on 07/05/2024.
//

import Foundation
import Alamofire

/// A service class responsible for making network requests to the recipe API Edamam.
class RecipeService {
    private let baseURL = "https://api.edamam.com/search" /// The base URL of the recipe API.
    private let apiKey = "a7e8a98d74d018d5e4b6cf3dfa7e89a5" /// The application ID for API access.
    private let appId = "6c8e05e9" /// The API key for authentication with the recipe service.
    
    /// Fetches recipes based on a list of ingredients.
    /// - Parameters:
    ///   - ingredients: A list of ingredients to search for in recipes.
    ///   - completion:  closure that is called when the fetch operation completes.
    func fetchRecipes(with ingredients: [String], completion: @escaping (Result<[RecipeResult], Error>) -> Void) {
        let ingredientsQuery = ingredients.joined(separator: ",")
        let query = RecipeQuery(q: ingredientsQuery, app_id: appId, app_key: apiKey)
        
        // Perform the network request using Alamofire.
        AF.request(baseURL, method: .get, parameters: query, encoder: URLEncodedFormParameterEncoder.default).responseDecodable(of: APIResponse.self) { response in
            // Handle the response by checking success or failure.
            switch response.result {
            case .success(let apiResponse):
                // Map the API response to an array of `RecipeResult`.
                let recipes = apiResponse.hits.map { $0.recipe }
                completion(.success(recipes))
            case .failure(let error):
                // Pass the error to the completion handler.
                completion(.failure(error))
            }
        }
    }
}
