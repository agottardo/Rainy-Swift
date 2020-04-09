//
//  LocationsManager.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-08.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

class LocationsManager {
    static let shared = LocationsManager()

    let storage = CodableStorage<[Location]>()

    var locations: [Location] {
        get {
            storage.read() ?? []
        }
        set {
            storage.save(newValue)
        }
    }

    private init() {}
}
