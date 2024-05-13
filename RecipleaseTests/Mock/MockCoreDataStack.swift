//
//  MockCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Thomas Carlier on 13/05/2024.
//

import Foundation
import CoreData
@testable import Reciplease

class MockCoreDataStack: CoreDataStack {
    override init() {
        super.init()

        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        self.persistentContainer = NSPersistentContainer(name: "Reciplease")
        self.persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]

        self.persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }

    override var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
}
