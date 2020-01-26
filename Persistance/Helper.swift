//
//  Helper.swift
//  Pursuit-Core-iOS-PhotoJournal-Assignment
//
//  Created by Tsering Lama on 1/23/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import Foundation

public enum Directory {
    case documentsDirectory
    case cachesDirectory
}

extension FileManager {
    // returns a URL to the documents directory
    // documents/
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func getCachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    // function that takes a filename, and adds it to the documents directory's URL
    // returns a path that will be used to write(save) data or read (get) data
    
    static func getPath(filename: String, directory: Directory) -> URL {
        switch directory {
        case .cachesDirectory:
            return getCachesDirectory().appendingPathComponent(filename)
        case .documentsDirectory:
            return getDocumentsDirectory().appendingPathComponent(filename)
        }
    }
}
