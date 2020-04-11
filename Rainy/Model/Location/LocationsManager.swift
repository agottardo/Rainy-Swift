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
    let settingsManager = SettingsManager.shared

    var locations: [Location] {
        get {
            storage.read(.locations) ?? []
        }
        set {
            storage.save(.locations, codable: newValue)
        }
    }

    var currentLocation: Location? {
        get {
            guard let index = settingsManager.currentLocationIndex,
                let location = locations[safe: index] else {
                Log.debug("Tried to access current location, but it has not been set yet.")
                return nil
            }
            return location
        }
        set {
            guard let newValue = newValue else {
                Log.warning("Setting current location to nil, was this intended?")
                settingsManager.currentLocationIndex = nil
                return
            }
            settingsManager.currentLocationIndex = locations.firstIndex(of: newValue)
            Log.debug("The current location is now: \(newValue.displayName)")
        }
    }

    private init() {}
}
