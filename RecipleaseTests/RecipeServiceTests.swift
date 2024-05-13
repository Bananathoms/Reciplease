//
//  RecipeServiceTests.swift
//  RecipleaseTests
//
//  Created by Thomas Carlier on 26/04/2024.
//

import XCTest
import Alamofire
@testable import Reciplease

class RecipeServiceTests: XCTestCase {
    var recipeService: RecipeService!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        let alamofireSession = Session(configuration: config)
        self.recipeService = RecipeService(session: alamofireSession)
    }
    
    override func tearDown() {
        self.recipeService = nil
        super.tearDown()
    }
    
    func testCreateSearchURLWithSingleIngredient() {
        let url = recipeService.createSearchUrl(with: ["lemon"])
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "https")
        XCTAssertEqual(url?.host, "api.edamam.com")
        XCTAssertEqual(url?.path, "/api/recipes/v2")
        XCTAssertTrue(url?.query?.contains("q=lemon") ?? false)
        XCTAssertTrue(url?.query?.contains("app_id=6c8e05e9") ?? false)
        XCTAssertTrue(url?.query?.contains("app_key=a7e8a98d74d018d5e4b6cf3dfa7e89a5") ?? false)
        XCTAssertTrue(url?.query?.contains("type=public") ?? false)
    }

    func testCreateSearchURLWithMultipleIngredients() {
        let url = recipeService.createSearchUrl(with: ["lemon", "sugar", "water"])
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "https")
        XCTAssertEqual(url?.host, "api.edamam.com")
        XCTAssertEqual(url?.path, "/api/recipes/v2")
        XCTAssertTrue(url?.query?.contains("q=lemon,sugar,water") ?? false)
        XCTAssertTrue(url?.query?.contains("app_id=6c8e05e9") ?? false)
        XCTAssertTrue(url?.query?.contains("app_key=a7e8a98d74d018d5e4b6cf3dfa7e89a5") ?? false)
        XCTAssertTrue(url?.query?.contains("type=public") ?? false)
    }

    func testCreateSearchURLWithNoIngredients() {
        let url = recipeService.createSearchUrl(with: [])
        XCTAssertNotNil(url)
        XCTAssertTrue(url?.query?.contains("q=") ?? false)
    }

    func testFetchRecipesSuccess() {
        let url = URL(string: "https://api.edamam.com/api/recipes/v2")!
        let sampleData = MockData.recipesData
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

        MockURLProtocol.mockResponses.append((request: URLRequest(url: url), response: response, data: sampleData))

        let expectation = self.expectation(description: "Fetch recipes succeeds")

        self.recipeService.fetchRecipes(from: url) { result in
            switch result {
            case .success(let (recipes, nextPageURL)):
                XCTAssertFalse(recipes.isEmpty, "Recipes should not be empty")
                XCTAssertNotNil(nextPageURL, "Next page URL should not be nil")
            case .failure(let error):
                XCTFail("Fetch recipes failed with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

}

