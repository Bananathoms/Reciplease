//
//  CoreDataHelperTests.swift
//  RecipleaseTests
//
//  Created by Thomas Carlier on 13/05/2024.
//

import Foundation
import XCTest
import CoreData
@testable import Reciplease

class CoreDataHelperTests: XCTestCase {
    var coreDataHelper: CoreDataHelper!
    var mockCoreDataStack: MockCoreDataStack!
    let testImage = UIImage(systemName: "star.fill")!
    let testFileName = "testImageFile"
    
    override func setUp() {
        super.setUp()
        
        mockCoreDataStack = MockCoreDataStack()
        CoreDataStack.shared = mockCoreDataStack
        
        coreDataHelper = CoreDataHelper.shared
    }
    
    override func tearDown() {
        coreDataHelper.deleteImage(fileName: testFileName)
        coreDataHelper = nil
        mockCoreDataStack = nil
        super.tearDown()
    }
    
    func testAddFavorite_ShouldSaveRecipe() {
        let recipe = RecipeResult(label: "Test Recipe", image: "image_url", url: "recipe_url", ingredientLines: ["Ingredient1", "Ingredient2"], totalTime: 30)
        
        coreDataHelper.addFavorite(recipe: recipe)
        
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        let results = try! coreDataHelper.context.fetch(fetchRequest)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.label, "Test Recipe")
    }
    
    func testRemoveFavorite_ShouldRemoveRecipe() {
        testAddFavorite_ShouldSaveRecipe()
        coreDataHelper.removeFavorite(recipeUrl: "recipe_url")
        
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        let results = try! coreDataHelper.context.fetch(fetchRequest)
        
        XCTAssertTrue(results.isEmpty)
    }
    
    func testFetchFavorites_ShouldReturnAllFavorites() {
        let recipe1 = RecipeResult(label: "Test Recipe", image: "image_url", url: "recipe_url", ingredientLines: ["Ingredient1"], totalTime: 30)
        let recipe2 = RecipeResult(label: "Another Test Recipe", image: "another_image_url", url: "another_recipe_url", ingredientLines: ["Ingredient2"], totalTime: 25)
        
        coreDataHelper.addFavorite(recipe: recipe1)
        coreDataHelper.addFavorite(recipe: recipe2)
        
        let results = coreDataHelper.fetchFavorites()
        
        XCTAssertEqual(results.count, 2)
    }
    
    func testSaveImage() {
        // When
        coreDataHelper.saveImage(image: testImage, fileName: testFileName)
        
        // Then
        let savedImage = coreDataHelper.loadImageFromDiskWith(fileName: testFileName)
        XCTAssertNotNil(savedImage, "Image should be successfully saved and loaded from disk.")
        XCTAssertEqual(testImage.pngData()?.count, savedImage?.pngData()?.count, "Saved image should match the original image in size.")
    }
    
    func testDeleteImage() {
        // Given
        coreDataHelper.saveImage(image: testImage, fileName: testFileName)
        
        // When
        coreDataHelper.deleteImage(fileName: testFileName)
        
        // Then
        let deletedImage = coreDataHelper.loadImageFromDiskWith(fileName: testFileName)
        XCTAssertNil(deletedImage, "Image should be nil after being deleted from disk.")
    }
    
    func testLoadImageFromDiskWithNonExistentFile() {
        // Given
        let nonExistentFileName = "nonExistentFile"
        
        // When
        let loadedImage = coreDataHelper.loadImageFromDiskWith(fileName: nonExistentFileName)
        
        // Then
        XCTAssertNil(loadedImage, "Image for non-existent file should be nil.")
    }
    
    func testDownloadAndSaveImage() {
        // Given
        let expectation = self.expectation(description: "Download image from URL")
        let imageURL = URL(string: "https://via.placeholder.com/150")!
        
        // When
        coreDataHelper.downloadAndSaveImage(from: imageURL, fileName: testFileName)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // Then
            let downloadedImage = self.coreDataHelper.loadImageFromDiskWith(fileName: self.testFileName)
            XCTAssertNotNil(downloadedImage, "Image should be successfully downloaded and saved to disk.")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetDocumentsDirectory() {
        // When
        let documentsDirectory = coreDataHelper.getDocumentsDirectory()
        
        // Then
        XCTAssertTrue(FileManager.default.fileExists(atPath: documentsDirectory.path), "Documents directory should exist.")
    }
}


