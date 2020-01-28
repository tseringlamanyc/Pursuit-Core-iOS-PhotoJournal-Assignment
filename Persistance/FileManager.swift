//
//  FileManager.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Tsering Lama on 1/23/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import Foundation

public enum DataPersistenceError: Error {
    case propertyListEncodingError(Error)
    case propertyListDecodingError(Error)
    case writingError(Error)
    case deletingError
    case noContentsAtPath(Error)
}

// step 1: Custom delegation - for data persistence
//protocol DataPersistenceDelegate: AnyObject {
//    func didDeleteItem<T>(persistenceHelper: DataPersistence<T>, item: T)
//}

typealias Writeable = Codable & Equatable

class DataPersistence<T: Writeable> {
    
    private let filename: String
    private var items: [T]
    
    // step 2: defining delegate as a reference property that will be registered as the object listening
    // weak var to break any strong referencees
    
    //weak var delegate: DataPersistenceDelegate?
    
    public init(filename: String) {
        self.filename = filename
        self.items = []
    }
    
    private func saveItemsToDocumentsDirectory() throws {
        do {
            let url = FileManager.getPath(filename: filename, directory: .documentsDirectory)
            let data = try PropertyListEncoder().encode(items)
            try data.write(to: url, options: .atomic)
        } catch {
            throw DataPersistenceError.writingError(error)
        }
    }
    
    // Create
    public func createItem(item: T) throws {
        _ = try? loadItems()
        items.append(item)
        do {
            try saveItemsToDocumentsDirectory()
        } catch {
            throw DataPersistenceError.writingError(error)
        }
    }
    
    // Read
    public func loadItems() throws -> [T] {
        let path = FileManager.getPath(filename: filename, directory: .documentsDirectory).path
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    items = try PropertyListDecoder().decode([T].self, from: data)
                } catch {
                    throw DataPersistenceError.propertyListDecodingError(error)
                }
            }
        }
        return items
    }
    
    // for re-ordering and keeping in sync
    public func sync(items: [T]) {
        self.items = items
        try? saveItemsToDocumentsDirectory()
    }
    
    // Delete
    public func deleteItems(index: Int) throws {
       items.remove(at: index)
        do {
            try saveItemsToDocumentsDirectory()
            
            // step 3 - use custom delegation reference to notify observer of deletion
           // delegate?.didDeleteItem(persistenceHelper: self, item: deletedItem)
        } catch {
            throw DataPersistenceError.deletingError
        }
    }
    
}
