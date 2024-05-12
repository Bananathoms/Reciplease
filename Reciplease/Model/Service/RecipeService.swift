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
    private let baseURL = "https://api.edamam.com/api/recipes/v2" /// The base URL of the recipe API.
    private let apiKey = "a7e8a98d74d018d5e4b6cf3dfa7e89a5" /// The application ID for API access.
    private let appId = "6c8e05e9" /// The API key for authentication with the recipe service.
    
    ///Fetches recipes based on a list of ingredients.
    /// - Parameters:
    ///   - ingredients: A list of ingredients used as query parameters to fetch recipes.
    ///   - completion: A completion handler that returns either a tuple containing an array of `RecipeResult` and an optional next page URL, or an error if the request fails.
    func fetchRecipes(with ingredients: [String], completion: @escaping (Result<([RecipeResult], String?), Error>) -> Void) {
        let ingredientsQuery = ingredients.joined(separator: ",")
        let queryParams: [String: String] = [
            "q": ingredientsQuery,
            "type": "public",
            "app_id": appId,
            "app_key": apiKey
        ]
        /// Ensure the URL is valid before attempting to make a network request.
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        /// Perform the network request to fetch recipes.
        AF.request(url, method: .get, parameters: queryParams, encoder: URLEncodedFormParameterEncoder.default).responseDecodable(of: APIResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                let recipes = apiResponse.hits.map { $0.recipe }
                let nextPageURL = apiResponse._links?.next?.href
                completion(.success((recipes, nextPageURL)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
