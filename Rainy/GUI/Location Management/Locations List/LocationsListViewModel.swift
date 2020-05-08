//
//  LocationsListViewModel.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-05-07.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import Foundation

final class LocationsListViewModel {
    var locationsManager: LocationsManager

    var locations: [Location] {
        LocationsManager.shared.locations
    }

    init(locationsManager: LocationsManager = .shared) {
        self.locationsManager = locationsManager
    }
}
