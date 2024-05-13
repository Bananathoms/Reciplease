//
//  CoreDataStackTests.swift
//  RecipleaseTests
//
//  Created by Thomas Carlier on 13/05/2024.
//

import Foundation
import XCTest
import CoreData
@testable import Reciplease

class CoreDataStackTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var mockPersistantContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        
        coreDataStack = CoreDataStack()
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.url = URL(fileURLWithPath: "/dev/null")

        coreDataStack.persistentContainer = NSPersistentContainer(name: "TestReciplease")
        coreDataStack.persistentContainer.persistentStoreDescriptions = [description]
        
        let expectation = self.expectation(description: "Load Persistent Stores")
        coreDataStack.persistentContainer.loadPersistentStores { (storeDescription, error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    override func tearDown() {
        let stores = coreDataStack.persistentContainer.persistentStoreCoordinator.persistentStores
        for store in stores {
            try? coreDataStack.persistentContainer.persistentStoreCoordinator.remove(store)
        }
        
        coreDataStack = nil
        super.tearDown()
    }

    func testSaveContext_WithChanges_ShouldSaveWithoutError() {
        let context = coreDataStack.context

        // Creating a mock entity to test saving
        let entity = NSEntityDescription.insertNewObject(forEntityName: "FavoriteRecipe", into: context)
        entity.setValue("Test Recipe", forKey: "label")

        XCTAssert(context.hasChanges, "Context should have changes after adding entity")
        XCTAssertNoThrow(coreDataStack.saveContext(), "Save context should not throw an error")
    }

    func testSaveContext_WithoutChanges_ShouldNotThrowError() {
        let context = coreDataStack.context
        XCTAssertFalse(context.hasChanges, "Context should have no changes initially")
        XCTAssertNoThrow(coreDataStack.saveContext(), "Save context should not throw error even without changes")
    }

    func testPersistentContainer_ShouldBeLoaded() {
        XCTAssertNotNil(coreDataStack.persistentContainer, "Persistent container should not be nil")
        XCTAssert(coreDataStack.persistentContainer.persistentStoreDescriptions.first?.type == NSInMemoryStoreType, "Persistent store should be in-memory for testing")
    }
    
}
