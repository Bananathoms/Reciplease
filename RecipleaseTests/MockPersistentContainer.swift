//
//  MockPersistentContainer.swift
//  RecipleaseTests
//
//  Created by Thomas Carlier on 13/05/2024.
//

import Foundation
import CoreData

class MockPersistentContainer: NSPersistentContainer {
    var shouldFailOnLoad: Bool = false
    
    override func loadPersistentStores(completionHandler block: @escaping (NSPersistentStoreDescription, Error?) -> Void) {
        if shouldFailOnLoad {
            let error = NSError(domain: "TestError", code: 1, userInfo: nil)
            block(NSPersistentStoreDescription(), error)
        } else {
            super.loadPersistentStores(completionHandler: block)
        }
    }
}
