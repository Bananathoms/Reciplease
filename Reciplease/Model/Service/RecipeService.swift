//
//  RecipeService.swift
//  Reciplease
//
//  Created by Thomas Carlier on 07/05/2024.
//

import Foundation
import Alamofire

class RecipeService {
    private let baseURL = "https://api.edamam.com/search"
    private let apiKey = "a7e8a98d74d018d5e4b6cf3dfa7e89a5"
    private let appId = "6c8e05e9"

    func fetchRecipes(with ingredients: [String], completion: @escaping (Result<[Recipe], Error>) -> Void) {
         let ingredientsQuery = ingredients.joined(separator: ",")
         let query = RecipeQuery(q: ingredientsQuery, app_id: appId, app_key: apiKey)

         AF.request(baseURL, method: .get, parameters: query, encoder: URLEncodedFormParameterEncoder.default).responseDecodable(of: APIResponse.self) { response in
             switch response.result {
             case .success(let apiResponse):
                 let recipes = apiResponse.hits.map { $0.recipe }
                 completion(.success(recipes))
             case .failure(let error):
                 completion(.failure(error))
             }
         }
     }
 }
