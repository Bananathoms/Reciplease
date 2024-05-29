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
    private var session: Session

    // Initialisation avec une session Alamofire
    init(session: Session = .default) {
        self.session = session
    }
    /// Creates a search URL for fetching recipes based on the provided ingredients.
    /// - Parameter ingredients: The list of ingredients to include in the search.
    /// - Returns: A fully formed URL ready for making a network request.
    func createSearchUrl(with ingredients: [String]) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: ingredients.joined(separator: ",")),
            URLQueryItem(name: "app_id", value: appId),
            URLQueryItem(name: "app_key", value: apiKey),
            URLQueryItem(name: "type", value: "public")
        ]
        return components?.url
    }
    
    /// Fetches recipes from a given URL and handles the network response.
    /// - Parameters:
    ///   - url: The URL from which to fetch the recipes.
    ///   - completion: A completion handler that returns either a tuple containing an array of `RecipeResult` and an optional next page URL, or an error if the request fails.
    func fetchRecipes(from url: URL, completion: @escaping (Result<([RecipeResult], String?), Error>) -> Void) {
        session.request(url, method: .get).responseDecodable(of: APIResponse.self) { response in
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
