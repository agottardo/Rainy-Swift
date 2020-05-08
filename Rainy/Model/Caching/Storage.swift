//
//  Storage.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2019-08-18.
//  Copyright © 2019 Andrea Gottardo. All rights reserved.
//

import Foundation

enum StorageError: Error {
    case fileDoesNotExist
}

enum StorageKey: String {
    case weatherCache
    case locations
}

final class CodableStorage<T> where T: Codable {
    func cacheLocation(forKey key: StorageKey) -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else {
            print("Could not get path.")
            return nil
        }
        let subfolder = "me.gottardo.Rainy.storage." + key.rawValue
        return URL(fileURLWithPath: path).appendingPathComponent(subfolder)
    }

    func save(_ key: StorageKey, codable: T) {
        guard let location = cacheLocation(forKey: key) else {
            print("Saving codable failed: could not get cache location.")
            return
        }

        do {
            let data = try JSONEncoder().encode(codable)
            try data.write(to: location)
        } catch {
            print("Saving codable for key \(key) failed: \(error)")
        }
    }

    func read(_ key: StorageKey) -> T? {
        guard let location = cacheLocation(forKey: key),
            FileManager.default.fileExists(atPath: location.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: location)
            return try? JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Reading codable failed: \(error)")
            return nil
        }
    }
}
