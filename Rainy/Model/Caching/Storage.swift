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

final class CodableStorage<T> where T: Codable {
    private var cacheLocation: URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                             .userDomainMask,
                                                             true).first else {
            print("Could not get path.")
            return nil
        }
        let subfolder = "me.gottardo.Rainy.weatherStore"
        return URL(fileURLWithPath: path).appendingPathComponent(subfolder)
    }

    func save(_ codable: T) {
        guard let location = cacheLocation else {
            print("Saving codable failed: could not get cache folder.")
            return
        }

        do {
            let data = try JSONEncoder().encode(codable)
            try data.write(to: location)
        } catch {
            print("Saving codable failed: \(error)")
        }
    }

    func read() -> T? {
        guard let location = cacheLocation,
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
